<?php
$file = 'data/login.json';
$valid = false;
if (file_exists($file)) {
    $data = json_decode(file_get_contents($file), true);
    if (isset($data['data']['subscriberId']) && isset($data['data']['userAuthenticateToken'])) {
        $valid = true;
    } else {
        // Delete the corrupted/failed login file so it doesn't block the login UI
        @unlink($file);
    }
}
echo json_encode(['exists' => $valid]);
