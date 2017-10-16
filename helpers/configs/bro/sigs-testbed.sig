signature sig-icmp {
	ip-proto == icmp
	event "ICMP Test detected. Testbed Heidelberg"
}
signature sig-http{
	ip-proto == tcp
	dst-port == 80
	event "HTTP Test detected. Testbed Heidelberg"
}
signature sig-ftp{
	ip-proto == tcp
	dst-port == 21
	event "FTP Test detected. Testbed Heidelberg"
}
signature sig-mysql{
	ip-proto == tcp
	dst-port == 3306
	event "MySQL Test detected. Testbed Heidelberg"
}
signature sig-ssl{
	ip-proto == tcp
	dst-port == 443
	event "SSL Test detected. Testbed Heidelberg"
}
