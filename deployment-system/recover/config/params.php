<?php
/**
 * 亲，为方便大家，已经把必须修改为自己配置的选项已经带上*****了
 * 此配置为测试配置，如果你不想消息泄露，请尽快修改为自己的邮箱smtp
 */
return [
    'user.passwordResetTokenExpire' => 3600,
    'user.emailConfirmationTokenExpire' => 43200, // 5 days有效

    // 头像图片后缀
    'user.avatar.extension' => [
        'jpg', 'png', 'jpeg',
    ],

    // *******操作日志目录*******
    'log.dir' => '/tmp/walle/',
    // *******指定公司邮箱后缀*******
    'mail-suffix' => [
        'misingularity.com', # 支持多个
    ],
];
