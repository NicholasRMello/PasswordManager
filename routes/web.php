<?php

use App\Http\Controllers\CredencialController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return redirect()->route('dashboard');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    
    // Rotas AJAX para funcionalidades especiais (devem vir ANTES do resource)
    Route::post('/credenciais/gerar-senha', [CredencialController::class, 'gerarSenha'])->name('credenciais.gerar-senha');
    Route::get('/credenciais/{credencial}/obter-senha', [CredencialController::class, 'obterSenha'])->name('credenciais.obter-senha');
    
    // Rotas para gerenciamento de credenciais
    Route::resource('credenciais', CredencialController::class)->parameters([
        'credenciais' => 'credencial'
    ]);

});

require __DIR__.'/auth.php';
