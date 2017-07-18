require "open-uri"
require "fileutils"
require "httparty"

class Repapllaw
  BASE_URL = "https://api.unsplash.com/photos/random"
  def initialize
    @client_id = "40a1764d9e4f48c64c87f5894a96634673d5a65cdd21af5ae0e421238534017c"
  end

  def execute
    photo = get_random_photo
    save_to_folder photo
    create_job unless job_existing?
  end

  private
  def get_desktop_size
    `eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";`
    resolution = %x`DISPLAY=:0 xdpyinfo | grep dimensions`
    @w, @h = resolution.match(/^[^0-9]*([0-9]+)x([0-9]+).*/i).captures
  end

  def get_random_photo
    get_desktop_size
    response = HTTParty.get BASE_URL, {query: {client_id: @client_id, w: @w, h: @h}}
    JSON.parse(response.body)["urls"]["custom"]
  end

  def save_to_folder photo_url
    extension = get_photo_extension photo_url
    path = `echo $HOME`
    path = path.gsub("\n", "")
    unless File.exists?("#{path}/repapllaw_photos")
      FileUtils.mkdir_p("#{path}/repapllaw_photos")
    end

    File.open("#{path}/repapllaw_photos/current."<<extension, "w+") do |f|
      f.write open(photo_url).read
    end
  end

  def get_photo_extension photo_url
    extension = photo_url.match(/&fm=([a-z]+)&/).captures.first
  end

  def job_existing?
    existing = `crontab -l | grep -q 'REPAPLLAW' && echo 'YES' || echo 'NO'`
    existing.strip == "YES"
  end

  def create_job
    path = `which gem repapllaw`
    path = path.strip.split("\n").last
    `(crontab -l 2>/dev/null; echo "* 1 * * * repapllaw # REPAPLLAW") | crontab -`
  end
end
