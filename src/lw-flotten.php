<?php
namespace LW\Flotten;

require('config.php');

/**
 * Berechnet die Flugzeit einer Flotte
 *
 * Diese Funktion berechnet die Flugzeit einer Flotte aus der übergebenen Entfernung, der Geschwindigkeit
 * und dem Antrieb. Die Parameter für die Antriebe werden aus der Konfiguration ausgelesen. Bei Flotten, die
 * aus Schiffen mit verschiedenen Antrieben bestehen, muss die Auswahl des langsamsten Antriebes extern erfolgen.
 *
 * @param   int     $entfernung         Entfernung, die die Flotte zurücklegt, in su
 * @param   float   $geschwindigkeit    Geschwindigkeit der Flotte als Dezimalwert [0.2, 1.6]
 * @param   string  $antrieb            Genutzter Antrieb [nuk, ion, hyp] (Konfigurierbar)
 * @return  int                         Flugzeit der Flotte in Sekunden
 * @throws  RuntimeException
 */
function flugzeit(int $entfernung, float $geschwindigkeit, string $antrieb) : int {
    if($entfernung < 1)
        throw new \RuntimeException("Entfernung außerhalb des erlaubten Bereiches [1, ...]: ".$entfernung);

    if($geschwindigkeit < 0.2 or $geschwindigkeit > 1.6)
        throw new \RuntimeException("Geschwindigkeit außerhalb des erlaubten Bereiches [0.2, 1.6]: ".$geschwindigkeit);

    if(!array_key_exists($antrieb, config['flotten']['antriebe']))
        throw new \RuntimeException("Antrieb nicht in der Liste der Antriebe [".implode(", ", array_keys(config['flotten']['antriebe']))."]: ".$antrieb);

    $c = config['flotten']['antriebe'][$antrieb];

    assert(in_array($c['typ'], ['beschleunigung', 'konstant']), "Konfiguration fehlerhaft - unbekannter Antriebs-Typ: ".$c['typ']);

    switch($c['typ']) {
    case 'beschleunigung':
        assert(array_key_exists('v_max', $c), "Konfiguration fehlerhaft - Parameter v_max fehlt in Antrieb ".$antrieb);
        assert(array_key_exists('t_to_v_max', $c), "Konfiguration fehlerhaft - Parameter t_to_v_max fehlt in Antrieb ".$antrieb);
        assert(array_key_exists('t_warmup', $c), "Konfiguration fehlerhaft - Parameter t_warmup fehlt in Antrieb ".$antrieb);

        if( ($entfernung - 0.75) < $c['v_max'] * $geschwindigkeit * $c['t_to_v_max'] ) {
            return 2 * sqrt(($entfernung - 0.75) / 2.0 / (0.5 * $c['v_max'] * $geschwindigkeit / $c['t_to_v_max'])) + $c['t_warmup'];
        } else {
            return $c['t_to_v_max'] + $c['t_warmup'] + ($entfernung - 0.75) / ($c['v_max'] * $geschwindigkeit);
        }
    case 'konstant':
        assert(array_key_exists('t', $c), "Konfiguration fehlerhaft - Parameter t fehlt in Antrieb ".$antrieb);

        return $c['t'];
    }
}

/**
 * Berechnet den Verbrauch einer Flotte
 *
 * Diese Funktion berechnet den Verbrauch einer Flotte aus der übergebenen Entfernung, der Geschwindigkeit
 * und dem Antrieb. Die Parameter für die Antriebe werden aus der Konfiguration ausgelesen. Bei Flotten, die
 * aus Schiffen mit verschiedenen Antrieben bestehen, muss der Verbrauch für jeden Antriebstyp einzeln bestimmt
 * werden.
 *
 * @param   int     $entfernung         Entfernung, die die Flotte zurücklegt, in su
 * @param   float   $geschwindigkeit    Geschwindigkeit der Flotte als Dezimalwert [0.2, 1.6]
 * @param   string  $antrieb            Genutzter Antrieb [nuk, ion, hyp] (Konfigurierbar)
 * @param   int     $gewicht            Gesamtgewicht der Flotte in btns
 * @return  int                         Verbrauch der Flotte in Frurozin
 * @throws  RuntimeException
 */
// TODO: gewicht!
function verbrauch(int $entfernung, float $geschwindigkeit, string $antrieb, int $gewicht) : int {
    if($entfernung < 1)
        throw new \RuntimeException("Entfernung außerhalb des erlaubten Bereiches [1, ...]: ".$entfernung);

    if($geschwindigkeit < 0.2 or $geschwindigkeit > 1.6)
        throw new \RuntimeException("Geschwindigkeit außerhalb des erlaubten Bereiches [0.2, 1.6]: ".$geschwindigkeit);

    if(!array_key_exists($antrieb, config['flotten']['antriebe']))
        throw new \RuntimeException("Antrieb nicht in der Liste der Antriebe [".implode(", ", array_keys(config['flotten']['antriebe']))."]: ".$antrieb);

    $c = config['flotten']['antriebe'][$antrieb];

    assert(in_array($c['typ'], ['beschleunigung', 'konstant']), "Konfiguration fehlerhaft - unbekannter Antriebs-Typ: ".$c['typ']);

    switch($c['typ']) {
    case 'beschleunigung':
        assert(array_key_exists('v_max', $c), "Konfiguration fehlerhaft - Parameter v_max fehlt in Antrieb ".$antrieb);
        assert(array_key_exists('t_to_v_max', $c), "Konfiguration fehlerhaft - Parameter t_to_v_max fehlt in Antrieb ".$antrieb);
        assert(array_key_exists('verbrauch_max', $c), "Konfiguration fehlerhaft - Parameter verbrauch_max fehlt in Antrieb ".$antrieb);
        assert(array_key_exists('verbrauch_pro_su', $c), "Konfiguration fehlerhaft - Parameter verbrauch_pro_su fehlt in Antrieb ".$antrieb);

        if( $entfernung < $c['v_max'] * $geschwindigkeit * $c['t_to_v_max'] ) {
            return (sqrt($entfernung / ($c['v_max'] * $geschwindigkeit / $c['t_to_v_max'])) / $c['t_to_v_max'] * $c['verbrauch_max'] * $geschwindigkeit) * $gewicht / 1000;
        } else {
            return ($c['verbrauch_max'] * $geschwindigkeit + ($entfernung - $c['v_max'] * $c['t_to_v_max']) * $c['verbrauch_pro_su'] * $geschwindigkeit) * $gewicht / 1000;
        }
    case 'konstant':
        assert(array_key_exists('verbrauch', $c), "Konfiguration fehlerhaft - Parameter verbrauch fehlt in Antrieb ".$antrieb);

        return $c['verbrauch'] * $gewicht / 1000;
    }
}
?>
