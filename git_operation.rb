system("git add -A")
system("git commit -m\"#{ARGV[0]}\"")
system("git push origin master")