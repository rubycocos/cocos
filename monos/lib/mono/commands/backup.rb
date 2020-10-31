module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.backup
    repos = Mono.monofile

    backup = GitBackup.new

    ## step 2: pass in all repos to backup by using
    ##   1) git clone --mirror or
    ##   2) git remote update  (if local backup already exists)
    backup.backup( repos )
  end # method backup

end  # module Mono
