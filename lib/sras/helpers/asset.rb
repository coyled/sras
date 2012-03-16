require 'sinatra/base'

module Sinatra
    module AssetHelper

        def get_asset_data(asset_id)
            @asset = Asset.get(asset_id)

            if @asset.enabled == false
                return
            end

            @asset_file = @asset.base_dir + '/' + @asset.sha256[0..2] + '/' + @asset.sha256[3..5] + '/' + @asset.sha256

            if File.exists?(@asset_file + '.gz')
                Zlib::GzipReader.open(@asset_file + '.gz') do |file|
                    @asset_data = file.read
                end
            elsif File.exists?(@asset_file)
                File.open(@asset_file) do |file|
                    @asset_data = file.read
                end
            end

            return @asset_data
        end

        def write_asset_data()
            @asset_file_dir = @asset.base_dir + '/' + @asset.sha256[0..2] + '/' + @asset.sha256[3..5]
            @asset_file = @asset_file_dir + '/' + @asset.sha256

            # see if asset file with this hash already exists.  if it
            # does, then we don't need to overwrite it with identical
            # data...
            if File.exists?(@asset_file + '.gz') || File.exists?(@asset_file)
                return
            end 

            # mkdirs if necessary...
            FileUtils.mkpath @asset_file_dir

            # write the data to a file, gzip'd...
            Zlib::GzipWriter.open(@asset_file + '.gz') do |file|
                file.write @asset_data
                file.close
            end
        end

        # Flags added to opensim in 9b22393.  Current values (from
        # OpenSim/Framework/AssetBase.cs):
        #
        #   [Flags]
        #   public enum AssetFlags : int
        #   {
        #       Normal = 0,
        #       Maptile = 1,
        #       Rewritable = 2,
        #       Collectable = 4
        #   }
        @flags = {
            'Normal'        => 0,
            'Maptile'       => 1,
            'Rewritable'    => 2,
            'Collectable'   => 4
        }

        # usage:
        #   asset_type = get_asset_type('image/tga')
        #   asset_type = get_asset_type(12)
        def get_asset_type(request)

            # default            'application/octet-stream'
            asset_type = {
                'image/jp2'                             => 0,
                'application/ogg'                       => 1,
                'application/x-metaverse-callingcard'   => 2,
                'application/x-metaverse-landmark'      => 3,
                'application/x-metaverse-clothing'      => 5,
                'application/x-metaverse-primitive'     => 6,
                'application/x-metaverse-notecard'      => 7,
                'application/x-metaverse-folder'        => 8,
                'application/x-metaverse-lsl'           => 10,
                'application/x-metaverse-lso'           => 11,
                'image/tga'                             => 12,
                'application/x-metaverse-bodypart'      => 13,
                'audio/x-wav'                           => 17,
                'image/jpeg'                            => 19,
                'application/x-metaverse-animation'     => 20,
                'application/x-metaverse-gesture'       => 21,
                'application/x-metaverse-simstate'      => 22
            }

            if asset_type[request]
                response = asset_type[request]
            elsif asset_type.invert[request]
                response = asset_type.invert[request]
            end

            return response

        end

    end

    helpers AssetHelper

end
