<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Vite Build Directory
    |--------------------------------------------------------------------------
    |
    | This value determines the "public" directory where Vite will place the
    | compiled assets. This should typically remain "build" unless you have
    | configured a custom build directory in your Vite configuration.
    |
    */

    'build_directory' => 'build',

    /*
    |--------------------------------------------------------------------------
    | Vite Manifest Path
    |--------------------------------------------------------------------------
    |
    | This value determines the path where Vite will place the manifest file
    | that contains the mapping of asset names to their versioned filenames.
    |
    */

    'manifest' => 'build/.vite/manifest.json',

    /*
    |--------------------------------------------------------------------------
    | Vite Hot File Path
    |--------------------------------------------------------------------------
    |
    | This value determines the path where Vite will place the "hot" file
    | that indicates the Vite development server is running. This is used
    | to determine whether to load assets from the dev server or build.
    |
    */

    'hot_file' => 'hot',

    /*
    |--------------------------------------------------------------------------
    | Development Server URL
    |--------------------------------------------------------------------------
    |
    | This value determines the URL of the Vite development server. This is
    | used when the hot file exists to load assets from the dev server.
    |
    */

    'dev_url' => env('VITE_DEV_SERVER_URL', 'http://localhost:5173'),

];