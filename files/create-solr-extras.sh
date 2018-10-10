# Folder and http is supported
artifactory=/opt/installs
package=HYBRISCOMM180800P_0-70003534
zip_extension=ZIP
contrib_zip_file=solr-contrib-$package
data_zip_file=solr-data-$package

script_path=$(dirname ${0} 2>/dev/null)
cd ${script_path}
echo ${script_path}
if [[ "$script_path" == "." ]]; then
  script_path=`pwd`
fi
hybris_bin=hybris/bin

if [[ $artifactory == "http*" ]]; then
  wget $artifactory/$package.$zip_extension
  unzip -q $package.$zip_extension $hybris_bin/ext-commerce/solrserver/**/* -d ./$package
  rm $package.$zip_extension
else
  unzip -q ${artifactory}/$package.$zip_extension $hybris_bin/ext-commerce/solrserver/**/* -d ./$package
fi

cd $script_path
mkdir -p ./solr

if [ -d ./$package/$hybris_bin/ext-commerce/solrserver/resources/solrCustomizations ]; then
  cp -f -R -r ./$package/$hybris_bin/ext-commerce/solrserver/resources/solrCustomizations/files/* ./solr/
elif [ ! -d ./$package/$hybris_bin/ext-commerce/solrserver/resources/solr/bin ]; then
  solrdir=$(find ./$package/$hybris_bin/ext-commerce/solrserver/resources/solr/ -mindepth 1 -maxdepth 1 -type d)
  cp -f -R -r ${solrdir}/customizations/files/* ./solr/
else
  mkdir -p ./solr/contrib
  cp -f -R ./$package/$hybris_bin/ext-commerce/solrserver/resources/solr/contrib/hybris ./solr/contrib/
  mkdir -p ./solr/server
  cp -f -R ./$package/$hybris_bin/ext-commerce/solrserver/resources/solr/server/solr ./solr/server/
fi

rm -rf $package

cd ./solr
if [ -d ./bin ]; then
  rm -rf ./bin
fi
zip -qr $contrib_zip_file.zip ./contrib
mv *.zip ${script_path}
cd ./server/solr
zip -qr $data_zip_file.zip .
mv *.zip ${script_path}

cd $script_path

rm -rf ./solr
