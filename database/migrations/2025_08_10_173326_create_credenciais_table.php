<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Executa as migrations para criar a tabela de credenciais.
     * Cada credencial pertence a um usuário e armazena informações de login criptografadas.
     */
    public function up(): void
    {
        Schema::create('credenciais', function (Blueprint $table) {
            $table->id();
            $table->foreignId('usuario_id')->constrained('users')->onDelete('cascade');
            $table->string('nome_servico'); // Nome do serviço/site (ex: Gmail, Facebook)
            $table->string('nome_usuario'); // Nome de usuário/email para login
            $table->text('senha_criptografada'); // Senha criptografada
            $table->timestamps(); // criado_em, atualizado_em
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('credenciais');
    }
};
