<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/health', function (Request $request) {
    return response()->json([
        "status" => "OK"
    ], 200);
});

Route::get('/ready', function (Request $request) {
    return response()->json([
        "status" => "OK"
    ], 200);
});
