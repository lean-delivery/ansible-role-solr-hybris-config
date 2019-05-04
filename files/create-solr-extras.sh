#!/bin/bash

# Folder and http is supported
default_artifactory=/opt/installs
default_package=HYBRISCOMM180800P_0-70003534
default_zip_extension=ZIP
artifactory=
package=
zip_extension=
contrib_zip_file=
data_zip_file=

# Help method
BASENAME=$(basename $0)
function help() {
    echo "Usage: ${BASENAME} [params]"
    echo "  params:"
    echo "    -a               folder or web source with hybris archive. Patches will be stored here too. Default is /opt/installs"
    echo "    -p               Hybris package name. Default is HYBRISCOMM180800P_0-70003534"
	  echo "    -e               Hybris package extension. Default is ZIP"
	  echo "    -c               Contrib file name. Default is solr-contrib-$package"
    echo "    -d               Elasticsearch index name. Default is solr-data-$package"
}

# Parse script params
while getopts ":a:p:e:c:d:" h_params; do
    case $h_params in
      a)
          artifactory=${OPTARG}
          ;;
	    p)
          package=${OPTARG}
          ;;
	    e)
          zip_extension=${OPTARG}
          ;;
	    c)
          contrib_zip_file=${OPTARG}
          ;;
	    d)
          data_zip_file=${OPTARG}
          ;;
      \?)
          echo >&2 "  [ERROR] Invalid option: -${OPTARG}"
          exit 1
          ;;
      :)
          echo >&2 "  [ERROR] Option -${OPTARG} requires an argument"
          exit 2
          ;;
    esac
done

# Set variables

if [ -z "$artifactory" ]; then
  echo "Setting artifactory"
  artifactory=$default_artifactory
fi

if [ -z "$package" ]; then
  package=$default_package
fi

if [ -z "$zip_extension" ]; then
  zip_extension=$default_zip_extension
fi

if [ -z "$contrib_zip_file" ]; then
  contrib_zip_file=solr-contrib-$package
fi

if [ -z "$data_zip_file" ]; then
  data_zip_file=solr-data-$package
fi

echo "artifactory: " ${artifactory}
echo "package: " ${package}
echo "zip_extension: " ${zip_extension}
echo "contrib_zip_file: " ${contrib_zip_file}
echo "data_zip_file: " ${data_zip_file}



script_path=$(dirname ${0} 2>/dev/null)
cd ${script_path}
echo ${script_path}
if [[ "$script_path" == "." ]]; then
  script_path=`pwd`
fi
hybris_bin=hybris/bin

if [[ $artifactory == http* ]]; then
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
echo "Contrib patch created:" $contrib_zip_file.zip
mv *.zip ${script_path}
cd ./server/solr
zip -qr $data_zip_file.zip .
echo "Data patch created:" $data_zip_file.zip
mv *.zip ${script_path}

cd $script_path

rm -rf ./solr
