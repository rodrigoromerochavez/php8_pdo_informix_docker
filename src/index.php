<?php

const FETCH_STYLE = 'fetch_style';
const QUERY = 'query';
const PARAMS = 'params';

$host = 'n_desarrollo';
$port = '9087';
$db = 'tbasesc';
$srv = 'ifxdesa';
$prt = 'onsoctcp';
$scrolCurs = '1';
$user = 'rmu';
$pwd = 'AdminBO123';

$pdo = new PDO(
    "informix:host=$host;" .
    "service=$port;" .
    "database=$db;" .
    "server=$srv;" .
    "protocol=$prt;" .
    "EnableScrollableCursors=$scrolCurs;",
    $user,
    $pwd
);

if (array_key_exists(QUERY, $_GET)) {
    $sql = $_GET[QUERY];
} else {
    $sql = 'SELECT CURRENT FROM systables WHERE tabid=1';
}

$params = [];

if (array_key_exists(PARAMS, $_GET)) {
    $params = $_GET[PARAMS];
}

if (array_key_exists(FETCH_STYLE, $_GET)) {
    $fetch_style = $_GET[FETCH_STYLE];
} else {
    $fetch_style = PDO::FETCH_ASSOC;
}

// Enable exceptions on PDO errors.
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$stm = $pdo->prepare($sql);
$stm->execute($params);
$results = $stm->fetchAll($fetch_style);
$response = json_encode($results, JSON_INVALID_UTF8_IGNORE);
$json_error = json_last_error() . ' ' . json_last_error_msg();

header('Content-Type: application/json');
echo $response;