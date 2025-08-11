<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Form Request para validação de dados de credenciais
 */
class CredencialRequest extends FormRequest
{
    /**
     * Determina se o usuário está autorizado a fazer esta requisição.
     * Apenas usuários autenticados podem gerenciar credenciais.
     */
    public function authorize(): bool
    {
        return auth()->check();
    }

    /**
     * Regras de validação para os dados da credencial.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'nome_servico' => 'required|string|max:255',
            'nome_usuario' => 'required|string|max:255',
            'senha' => 'required|string|min:1',
        ];
    }

    /**
     * Mensagens de erro personalizadas em português.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'nome_servico.required' => 'O nome do serviço é obrigatório.',
            'nome_servico.string' => 'O nome do serviço deve ser um texto.',
            'nome_servico.max' => 'O nome do serviço não pode ter mais de 255 caracteres.',
            
            'nome_usuario.required' => 'O nome de usuário é obrigatório.',
            'nome_usuario.string' => 'O nome de usuário deve ser um texto.',
            'nome_usuario.max' => 'O nome de usuário não pode ter mais de 255 caracteres.',
            
            'senha.required' => 'A senha é obrigatória.',
            'senha.string' => 'A senha deve ser um texto.',
            'senha.min' => 'A senha deve ter pelo menos 1 caractere.',
        ];
    }

    /**
     * Nomes dos atributos para as mensagens de erro.
     *
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'nome_servico' => 'nome do serviço',
            'nome_usuario' => 'nome de usuário',
            'senha' => 'senha',
        ];
    }
}
