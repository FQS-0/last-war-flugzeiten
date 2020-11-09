<?php

if( version_compare(PHP_VERSION, '7.0.0', '<') )
    throw new RuntimeException("Es wird mindesten PHP 7.0 benötigt: ".PHP_VERSION);

$config = [
    'flotten' => [
        'antriebe' => [
            'nuk' => [
                'typ' => 'beschleunigung',
                'v_max' => 10 / 3600,
                't_to_v_max' => 1 * 3600,
                't_warmup' => 1 * 3600,
                'verbrauch_max' => 20,
                'verbrauch_pro_su' => 0
            ],
            'ion' => [
                'typ' => 'beschleunigung',
                'v_max' => 25 / 3600,
                't_to_v_max' => 2 * 3600,
                't_warmup' => 2.5 * 3600,
                'verbrauch_max' => 8,
                'verbrauch_pro_su' => 0
            ],
            'hyp' => [
                'typ' => 'beschleunigung',
                'v_max' => 500 / 3600,
                't_to_v_max' => 0.125 * 3600,
                't_warmup' => 4.5 * 3600,
                'verbrauch_max' => 100,
                'verbrauch_pro_su' => 0.05
            ],
            'gty' => [
                'typ' => 'konstant',
                't' => 4.5 * 3600,
                'verbrauch' => 200
            ]
        ]
    ]
];

define('config', $config);

?>
