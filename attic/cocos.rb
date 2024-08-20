################
#  private helpers - keep along here - why? why not?

##### check if path starts with http:// or https://
##       if yes, assume it's a download
DOWNLOAD_RX = %r{^https?://}i

## note: hack - use !! to force nil (no match) to false
##                         and matchdata to true
def _download?( path )
   !! DOWNLOAD_RX.match( path )
end


## todo:  add symbolize options a la read_json
##         add sep options
def read_csv( path, headers: true )

   if _download?( path )
     parse_csv( _wget!( path ).text,
                headers: headers )
   else
     if headers
        CsvHash.read( path )
     else
        Csv.read( path )
     end
    end
end

def parse_csv( str, headers: true )
  if headers
    CsvHash.parse( str )
  else
    Csv.parse( str )
  end
end


