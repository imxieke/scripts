# Install a Webserver
apt-get -y install apache2
# Target docroot to /home/satis/web/


# Install PHP5 CLI and needed programs.
apt-get -y install php5-cli php5-curl php5-json git wget

# Add a specifix user for our task
adduser satis

# Install satis
su - satis
cd ~
wget http://getcomposer.org/composer.phar
mkdir web

# Add a github key, so we will not be limited to 60 API Request/Hour, but 6000.
# --> https://gist.github.com/h4cc/7680054
php composer.phar config --global github-oauth.github.com YOUR_GITHUB_KEY


# Configure Satis
# This file should be versioned with svn/git.

# satis.json
{
    "name": "COMPANY_NAME Composer Mirror",
    "homepage": "http://composer.example.com/",
    "repositories": [
        {
            "type": "composer",
            "url": "http://packagist.org"
        }
    ],
    "require": {
        "phpunit/phpunit": "*",
        "phpmd/phpmd": "*",
        "phploc/phploc": "*",
        "pdepend/pdepend": "*",
        "squizlabs/php_codesniffer": "*",
        "sebastian/phpcpd": "*",
        "sensiolabs/security-checker": "*"
    },
    "require-dependencies": true,
    "archive": {
        "directory": "dist",
        "format": "zip"
    }
}

# Run satis
php satis/bin/satis build satis.json web/
# This will download the ZIP Archives to web/dist
# At the end, a web/index.html and web/packages.json will be created.


#--- Project configuration in composer.json

# Using mirror, then packagist.org.
{
    "repositories": [
        {
            "type": "composer",
            "url": "http://composer.example.com/"
        }
    ]
}

# ONLY using mirror.
{
    "repositories": [
        {
            "packagist": false
        },
        {
            "type": "composer",
            "url": "http://composer.example.com/"
        }
    ]
}


# Background Info:

Satis will use a tmp dir for downloading and creating archives.
$ ls /tmp/composer_archiver/
To change that directory path, use the TMPDIR env variable:
TMPDIR="/path/to/dir" php composer.phar install
# Source: https://github.com/composer/composer/issues/1554
# Source: http://php.net/manual/de/function.sys-get-temp-dir.php

Composer has a config dir:
$ ls /home/satis/.composer/
In case there is a stupid error, remove the composer cache and try again:
$ rm -rf /home/satis/.composer/cache

