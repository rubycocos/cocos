##############
# experimental stuff
#

module Mono

######################
### lint/print mono (source) tree
###   - check for git repos (via .git/ dir)
#
#  turn into
#   - tree or
#   - lint or
#   - doctor or
#   - check or such command - why? why not?
def self.walk( path=root)
   repos = walk_dir( path )
   repos
end


###############
# private helpers
private

## todo/check - use max_depth or max_level or such - why? why not?
def self.walk_dir( path, repos=[], level=1, depth: nil )
  entries = Dir.entries(path)

  ## filter dirs
  dirs = entries.select do |entry|
    if ['..', '.'].include?( entry )  ## first check for excludes
      false
    else
      full_path = File.join( path, entry )
      File.directory?( full_path )
    end
  end

  if dirs.size == 0   ## shortcircuit - no dirs in dir
    return repos
  end

  repos_count = 0  ## note: local (only) repos count
  warns_count = 0
  sub_dirs = []



  buf = String.new('')    ## use an output buffer (allows optional print)


  buf << ">#{path}< - level #{level}:\n"
  dirs.each do |entry|
    next if ['..', '.', '.git'].include?( entry )
    full_path = File.join( path, entry )

    if Dir.exist?( File.join( full_path, '.git' ))
      repos_count += 1

      if level == 1
        warns_count += 1
        buf << "!! WARN - top-level repo (w/o user/org) >#{entry}< @ #{path}\n"
      end

      if level > 2
        warns_count += 1
        buf << "!! WARN - hidden (?) sub-level #{level} repo (nested too deep?) >#{entry}< @ #{path}\n"
      end

      buf << "    repo ##{'%-2d' % repos_count} | "
      buf << "#{'%-20s' % entry} @ #{File.basename(path)} (#{path})"
      buf << "\n"
      repos << full_path

    ## check for bare bone git repos  - todo/fix: add .gitconfig or such and more - why? why not?
    elsif Dir.exist?( File.join( full_path, 'hooks' )) &&
          Dir.exist?( File.join( full_path, 'info' )) &&
          Dir.exist?( File.join( full_path, 'objects' )) &&
          Dir.exist?( File.join( full_path, 'refs' ))
      warns_count += 1
      buf << "!! WARN - skip bare git repo >#{entry}< @ #{path}\n"
    else
      buf << "     x  >#{entry}<\n"
      sub_dirs << entry
    end
  end
  buf << "  #{repos_count} repos(s), #{dirs.size} dir(s), #{warns_count} warn(s)\n"
  buf << "\n"

  ## note: skip output of "plain" diretory listings (no repos, no warnings)
  puts buf   if repos_count > 0 || warns_count > 0


  sub_dirs.each do |entry|
    ## continue walking
    full_path = File.join( path, entry )
    walk_dir( full_path, repos, level+1, depth: depth )
  end

  repos
end

end  # module Mono