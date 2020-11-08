<?php

require('lw-flotten.php');

$data = fopen('../plots/flugzeiten-galaintern.txt', 'w');

fwrite($data, "# Entfernung Nuk100 Nuk130 Nuk160 Ion100 Ion130 Ion160 Hyp100 Gty 100%\n");

for($entfernung = 1; $entfernung <=100; $entfernung++) {
    $line = [$entfernung];
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1, 'nuk')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1.3, 'nuk')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1.6, 'nuk')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1, 'ion')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1.3, 'ion')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1.6, 'ion')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1, 'hyp')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1, 'gty')/3600);

    fwrite($data, implode(' ', $line)."\n");
}

fclose($data);

$data = fopen('../plots/flugzeiten-galaextern.txt', 'w');

fwrite($data, "# Entfernung Hyp100 Hyp130 Hyp160 Gty100\n");

for($entfernung = 1; $entfernung <=5000; $entfernung += 50) {
    $line = [$entfernung];
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1, 'hyp')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1.3, 'hyp')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1.6, 'hyp')/3600);
    array_push($line, \LW\Flotten\flugzeit($entfernung, 1, 'gty')/3600);

    fwrite($data, implode(' ', $line)."\n");
}

fclose($data);

$data = fopen('../plots/verbrauch-galaintern.txt', 'w');

fwrite($data, "# Entfernung Nuk100 Nuk130 Nuk160 Ion100 Ion130 Ion160 Hyp100 Gty 100%\n");

for($entfernung = 1; $entfernung <=100; $entfernung++) {
    $line = [$entfernung];
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1, 'nuk', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1.3, 'nuk', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1.6, 'nuk', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1, 'ion', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1.3, 'ion', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1.6, 'ion', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1, 'hyp', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1, 'gty', 1000));

    fwrite($data, implode(' ', $line)."\n");
}

fclose($data);

$data = fopen('../plots/verbrauch-galaextern.txt', 'w');

fwrite($data, "# Entfernung Hyp100 Hyp130 Hyp160 Gty100\n");

for($entfernung = 1; $entfernung <=5000; $entfernung += 50) {
    $line = [$entfernung];
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1, 'hyp', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1.3, 'hyp', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1.6, 'hyp', 1000));
    array_push($line, \LW\Flotten\verbrauch($entfernung, 1, 'gty', 1000));

    fwrite($data, implode(' ', $line)."\n");
}

fclose($data);

?>
