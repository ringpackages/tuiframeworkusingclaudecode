func main
	C_LINESIZE = 80
	? copy("=",C_LINESIZE)
	? "TUIFrameworkUsingClaudeCode Package"
	? copy("=",C_LINESIZE)
	? "TUIFrameworkUsingClaudeCode package for the Ring programming language"
	? "See the folder : ring/applications/tuidemo"
	? copy("=",C_LINESIZE)
	cDir = currentdir()
	chdir(exefolder()+"/../applications/tuidemo")
	system("ring demo.ring")
	chdir(cDir)