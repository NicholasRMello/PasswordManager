<?php

namespace App\Http\Controllers;

use App\Http\Requests\CredencialRequest;
use App\Models\Credencial;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Str;
use Illuminate\View\View;

/**
 * Controller para gerenciar credenciais de usuários
 * Implementa CRUD completo com segurança e criptografia
 */
class CredencialController extends Controller
{
    /**
     * Exibe a listagem de todas as credenciais do usuário autenticado.
     */
    public function index(): View
    {
        // Busca apenas as credenciais do usuário logado
        $credenciais = Credencial::where('usuario_id', auth()->id())->latest()->get();
        
        return view('credenciais.index', compact('credenciais'));
    }

    /**
     * Exibe o formulário para criar uma nova credencial.
     */
    public function create(): View
    {
        return view('credenciais.create');
    }

    /**
     * Armazena uma nova credencial no banco de dados.
     */
    public function store(CredencialRequest $request): RedirectResponse
    {
        // Cria nova credencial com dados validados
        $credencial = new Credencial();
        $credencial->usuario_id = auth()->id();
        $credencial->nome_servico = $request->nome_servico;
        $credencial->nome_usuario = $request->nome_usuario;
        $credencial->setSenha($request->senha); // Criptografa a senha
        $credencial->save();
        
        return redirect()->route('credenciais.index')
            ->with('sucesso', 'Credencial criada com sucesso!');
    }

    /**
     * Exibe uma credencial específica (não implementado por segurança).
     */
    public function show(Credencial $credencial): RedirectResponse
    {
        // Redireciona para a listagem por questões de segurança
        return redirect()->route('credenciais.index');
    }

    /**
     * Exibe o formulário para editar uma credencial existente.
     */
    public function edit(Credencial $credencial): View
    {
        // Verifica se a credencial pertence ao usuário logado
        if ($credencial->usuario_id !== auth()->id()) {
            abort(403, 'Acesso negado.');
        }
        
        return view('credenciais.edit', compact('credencial'));
    }

    /**
     * Atualiza uma credencial existente no banco de dados.
     */
    public function update(CredencialRequest $request, Credencial $credencial): RedirectResponse
    {
        // Verifica se a credencial pertence ao usuário logado
        if ($credencial->usuario_id !== auth()->id()) {
            abort(403, 'Acesso negado.');
        }
        
        // Atualiza os dados da credencial
        $credencial->nome_servico = $request->nome_servico;
        $credencial->nome_usuario = $request->nome_usuario;
        $credencial->setSenha($request->senha); // Criptografa a nova senha
        $credencial->save();
        
        return redirect()->route('credenciais.index')
            ->with('sucesso', 'Credencial atualizada com sucesso!');
    }

    /**
     * Remove uma credencial do banco de dados.
     */
    public function destroy(Credencial $credencial)
    {
        // Verificar se a credencial pertence ao usuário logado
        if ($credencial->usuario_id !== auth()->id()) {
            if (request()->expectsJson()) {
                return response()->json(['error' => 'Não autorizado'], 403);
            }
            return redirect()->route('credenciais.index')->with('erro', 'Você não tem permissão para excluir esta credencial.');
        }

        $credencial->delete();

        if (request()->expectsJson()) {
            return response()->json(['message' => 'Credencial excluída com sucesso']);
        }
 
        return redirect()->route('credenciais.index')->with('sucesso', 'Credencial excluída com sucesso!');
    }



    /**
     * Gera uma senha segura aleatória.
     * Endpoint AJAX para o gerador de senhas.
     */
    public function gerarSenha(Request $request)
    {
        $tamanho = $request->input('tamanho', 16); // Tamanho padrão: 16 caracteres
        $tamanho = max(8, min(64, $tamanho)); // Limita entre 8 e 64 caracteres
        
        // Caracteres disponíveis para a senha
        $maiusculas = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $minusculas = 'abcdefghijklmnopqrstuvwxyz';
        $numeros = '0123456789';
        $simbolos = '!@#$%^&*()_+-=[]{}|;:,.<>?';
        
        // Garante pelo menos um caractere de cada tipo
        $senha = '';
        $senha .= $maiusculas[random_int(0, strlen($maiusculas) - 1)];
        $senha .= $minusculas[random_int(0, strlen($minusculas) - 1)];
        $senha .= $numeros[random_int(0, strlen($numeros) - 1)];
        $senha .= $simbolos[random_int(0, strlen($simbolos) - 1)];
        
        // Preenche o restante da senha
        $todosCaracteres = $maiusculas . $minusculas . $numeros . $simbolos;
        for ($i = 4; $i < $tamanho; $i++) {
            $senha .= $todosCaracteres[random_int(0, strlen($todosCaracteres) - 1)];
        }
        
        // Embaralha a senha para randomizar a posição dos caracteres obrigatórios
        $senha = str_shuffle($senha);
        
        return response()->json(['senha' => $senha]);
    }

    /**
     * Retorna a senha descriptografada para cópia.
     * Endpoint AJAX para copiar senha.
     */
    public function obterSenha(Credencial $credencial)
    {
        // Verifica se a credencial pertence ao usuário logado
        if ($credencial->usuario_id !== auth()->id()) {
            abort(403, 'Acesso negado.');
        }
        
        return response()->json(['senha' => $credencial->getSenha()]);
    }
}
