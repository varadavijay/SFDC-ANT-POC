set OUTDIR=SchemaSpy
REM java -cp %CP% net.sourceforge.schemaspy.Main -t force -u USERNAME -p PASSWORDANDSECKEY -font Arial -fontsize 8 -hq  -norows -o %OUTDIR% -connprops custom\=true;standard\=false
java -cp schemaSpy_5.0.0.jar;force-metadata-jdbc-driver-2.2.jar net.sourceforge.schemaspy.Main -t force -u vvarada@gannet.com.vvarada1 -p Welcome1bHWagGPnOn6rEHnxsUobGqRa -font Arial -fontsize 8 -hq -norows -o %OUTDIR% -desc "Extracted from MyDbName on Force.com" -connprops "includes\=Account,Contact;url\=https://test.salesforce.com/services/Soap/u/21.0" 
REM -connprops custom\=false;standard\=false