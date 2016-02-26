#!/bin/bash
set -e

MYSQL_PARAMS="-h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD}"

mysql ${MYSQL_PARAMS} -e 'DROP DATABASE IF EXISTS magento2;'
mysql ${MYSQL_PARAMS} -e 'CREATE DATABASE IF NOT EXISTS magento2;'

MAGENTO_CONSOLE=bin/magento

COMMANDS=(
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:install
        --backend-frontname=admin
        --session-save=db
        --db-host=${MYSQL_HOST}
        --db-name=${MYSQL_DATABASE}
        --db-user=${MYSQL_USER}
        --base-url=http://${MAGENTO_HOST}/
        --language=en_US
        --timezone=America/Sao_Paulo
        --currency=USD
        --admin-lastname=Admin
        --admin-firstname=Admin
        --admin-email=admin@example.com
        --admin-user=admin
        --admin-password=123123q"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE deploy:mode:set developer"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:performance:generate-fixtures $MAGENTO_PATH/setup/performance-toolkit/profiles/ce/small.xml"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:static-content:deploy"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:di:compile"
    )

ELEMENTS=${#COMMANDS[@]}

for (( i=0;i<$ELEMENTS;i++)); do
    echo "${COMMANDS[${i}]}"
    ${COMMANDS[${i}]}
    case "$i" in
    0) echo 'Update Magento configuration'
        mysql ${MYSQL_PARAMS} -e "INSERT INTO \`magento2\`.\`core_config_data\`
        (\`path\`, \`value\`)
        VALUES
        ('dev/template/minify_html', 1),
        ('dev/js/enable_js_bundling', 1),
        ('dev/js/merge_files', 1),
        ('dev/js/minify_files', 1),
        ('dev/css/merge_css_files', 1),
        ('dev/css/minify_files', 1),
        ('web/seo/use_rewrites', 1),
        ('web/url/redirect_to_base', 1),
        ('admin/security/use_form_key', 1)
        ON DUPLICATE KEY UPDATE \`value\` = VALUES(\`value\`);"
    ;;
    2) echo 'Remove static and generated files'
        rm -R -f $MAGENTO_PATH/var/* $MAGENTO_PATH/pub/static/*
    ;;
    4)
        chown -R www-data:www-data $MAGENTO_PATH/var $MAGENTO_PATH/pub/static
    ;;
    esac
done

chown -R www-data:www-data $MAGENTO_PATH
chmod -R 777 $MAGENTO_PATH/var $MAGENTO_PATH/pub/static
