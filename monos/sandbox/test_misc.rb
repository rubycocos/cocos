$LOAD_PATH.unshift( "./lib" )
require 'mono'

puts
puts Mono.root


puts Monopath.real_path( 'hello.txt@tmp/test' )


puts Monopath.read_utf8( 'hello.txt@tmp/test' )
pp Monopath.exist?( 'hello.txt@tmp/test' )
pp Monopath.exist?( 'hola.txt@tmp/test' )


Monopath.open( 'test.txt@tmp/test', 'w:utf-8' ) do |f|
  f.write( "test test test\n" )
  f.write( "#{Time.now}\n")
end

MonoGitProject.open( 'erste-schritte@testgit') do |proj|
   puts proj.status
   puts proj.changes?
end



Mono.open( 'erste-schritte@testgit') do |proj|
  puts proj.status
  puts proj.changes?
end

Mono.root = "/Sites/tmp/#{Time.now.to_i}"
puts Mono.root


MonoGitHub.clone( 'fotos@rubycoco')

MonoGitProject.open( 'fotos@rubycoco' ) do |proj|
  puts proj.status
  puts proj.changes?
end

Mono.clone( 'gutenberg@rubycoco', depth: 1 )
## Mono.clone( 'fizzubuzzer@rubycoco' )
