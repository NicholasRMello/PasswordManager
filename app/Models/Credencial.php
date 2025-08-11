<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Crypt;

/**
 * Model para gerenciar credenciais de usuários
 * 
 * @property int $id
 * @property int $usuario_id
 * @property string $nome_servico
 * @property string $nome_usuario
 * @property string $senha_criptografada
 * @property \Illuminate\Support\Carbon $created_at
 * @property \Illuminate\Support\Carbon $updated_at
 */
class Credencial extends Model
{
    use HasFactory;

    /**
     * Nome da tabela no banco de dados
     */
    protected $table = 'credenciais';

    /**
     * Define o nome do parâmetro de rota para este model
     */
    public function getRouteKeyName()
    {
        return 'id';
    }

    /**
     * Campos que podem ser preenchidos em massa
     */
    protected $fillable = [
        'usuario_id',
        'nome_servico',
        'nome_usuario',
        'senha_criptografada',
    ];

    /**
     * Relacionamento: Uma credencial pertence a um usuário
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }

    /**
     * Criptografa e salva a senha
     */
    public function setSenha(string $senha): void
    {
        $this->senha_criptografada = Crypt::encryptString($senha);
    }

    /**
     * Descriptografa e retorna a senha
     */
    public function getSenha(): string
    {
        return Crypt::decryptString($this->senha_criptografada);
    }
}
