require 'digest/md5'

module DiatoArranger
  class TunesRepository < Struct.new(:path)
    def create(abc)
      hash = Digest::MD5.hexdigest(abc)
      File.open(filename(hash), "w") { |f| f.write(abc) }
      hash
    end

    def get(hash)
      File.read(filename(hash))
    end

    def filename(hash)
      File.expand_path("#{hash}.abc", path)
    end
  end
end