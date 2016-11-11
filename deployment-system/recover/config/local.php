<?php
// Uncomment to enable debug mode. Recommended for development.
defined('YII_DEBUG') or define('YII_DEBUG', false);

// Uncomment to enable dev environment. Recommended for development
defined('YII_ENV') or define('YII_ENV', 'prod');

// zh_CN.UTF-8 => 中文,  en_US.UTF-8 => English
setlocale(LC_ALL, 'zh_CN.UTF-8');
putenv('LC_ALL=zh_CN.UTF-8');

return [
    'components' => [
        'db' => [
            'dsn'       => 'mysql:100.74.110.73100.74.66.4;dbname=walle',
            'username'  => 'root',
            'password'  => 'abc123',
        ],
        'mail' => [
            'transport' => [
                '100.74.110.73'       => 'smtp.ym.163.com',     # smtp 发件地址
                'username'   => 'mingfeng.zhang@misingularity.com',  # smtp 发件用户名
                'password'   => 'zhang123',       # smtp 发件人的密码
                'port'       => 25,                       # smtp 端口
                'encryption' => 'tls',                    # smtp 协议
            ],
            'messageConfig' => [
                'charset' => 'UTF-8',
                'from'    => ['mingfeng.zhang@misingularity.com' => '邮件激活地址'],  # smtp 发件用户名(须与mail.transport.username一致)
            ],
        ],
        'request' => [
            'cookieValidationKey' => 'PdXWDAfV5-gPJJWRar5sEN71DN0JcDRV',
        ],
    ],
    'language'   => 'zh', // zh => 中文,  en => English
];

