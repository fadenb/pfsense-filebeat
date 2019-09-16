ELK_PfSense
Run from command line to install:

fetch -o - https://git.io/JeO3f | sh -s

Optional add menu item by add this to the service section of /cf/conf/config.xml

<service>
	<name>filebeat</name>
	<rcfile>filebeat</rcfile>
	<executable>filebeat</executable>
	<description><![CDATA[Filebeat service]]></description>
</service>
