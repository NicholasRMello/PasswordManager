<x-app-layout>
    <x-slot name="header">
        <div class="flex justify-between items-center">
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                {{ __('Nova Credencial') }}
            </h2>
            <a href="{{ route('credenciais.index') }}" 
               class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded">
                Voltar
            </a>
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-2xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    <form action="{{ route('credenciais.store') }}" method="POST">
                        @csrf
                        
                        <!-- Nome do Serviço -->
                        <div class="mb-4">
                            <label for="nome_servico" class="block text-sm font-medium text-gray-700 mb-2">
                                Nome do Serviço *
                            </label>
                            <input type="text" 
                                   id="nome_servico" 
                                   name="nome_servico" 
                                   value="{{ old('nome_servico') }}"
                                   placeholder="Ex: Gmail, Facebook, GitHub"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 @error('nome_servico') border-red-500 @enderror">
                            @error('nome_servico')
                                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                            @enderror
                        </div>

                        <!-- Nome de Usuário -->
                        <div class="mb-4">
                            <label for="nome_usuario" class="block text-sm font-medium text-gray-700 mb-2">
                                Nome de Usuário/Email *
                            </label>
                            <input type="text" 
                                   id="nome_usuario" 
                                   name="nome_usuario" 
                                   value="{{ old('nome_usuario') }}"
                                   placeholder="Ex: usuario@email.com"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 @error('nome_usuario') border-red-500 @enderror">
                            @error('nome_usuario')
                                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                            @enderror
                        </div>

                        <!-- Senha -->
                        <div class="mb-6">
                            <label for="senha" class="block text-sm font-medium text-gray-700 mb-2">
                                Senha *
                            </label>
                            <div class="flex space-x-2">
                                <input type="password" 
                                       id="senha" 
                                       name="senha" 
                                       value="{{ old('senha') }}"
                                       placeholder="Digite ou gere uma senha segura"
                                       class="flex-1 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 @error('senha') border-red-500 @enderror">
                                <button type="button" 
                                        onclick="toggleSenhaVisibilidade()"
                                        class="bg-gray-500 hover:bg-gray-700 text-white px-3 py-2 rounded">
                                    👁️
                                </button>
                                <button type="button" 
                                        onclick="gerarSenhaSegura()"
                                        class="bg-green-500 hover:bg-green-700 text-white px-4 py-2 rounded">
                                    Gerar Senha
                                </button>
                            </div>
                            @error('senha')
                                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                            @enderror
                            <p class="mt-1 text-sm text-gray-500">
                                Use o botão "Gerar Senha" para criar uma senha segura automaticamente.
                            </p>
                        </div>

                        <!-- Configurações do Gerador de Senha -->
                        <div class="mb-6 p-4 bg-gray-50 rounded-lg">
                            <h3 class="text-sm font-medium text-gray-700 mb-3">Configurações do Gerador de Senha</h3>
                            <div class="flex items-center space-x-4">
                                <label for="tamanho_senha" class="text-sm text-gray-600">
                                    Tamanho:
                                </label>
                                <input type="range" 
                                       id="tamanho_senha" 
                                       min="8" 
                                       max="32" 
                                       value="16" 
                                       class="flex-1">
                                <span id="tamanho_valor" class="text-sm font-medium text-gray-700">16</span>
                            </div>
                        </div>

                        <!-- Botões de Ação -->
                        <div class="flex justify-end space-x-4">
                            <a href="{{ route('credenciais.index') }}" 
                               class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded">
                                Cancelar
                            </a>
                            <button type="submit" 
                                    class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                                Salvar Credencial
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript para funcionalidades do formulário -->
    <script>
        // Controla a visibilidade da senha
        function toggleSenhaVisibilidade() {
            const senhaInput = document.getElementById('senha');
            const tipo = senhaInput.type === 'password' ? 'text' : 'password';
            senhaInput.type = tipo;
        }

        // Atualiza o valor exibido do tamanho da senha
        document.getElementById('tamanho_senha').addEventListener('input', function() {
            document.getElementById('tamanho_valor').textContent = this.value;
        });

        // Gera uma senha segura
        async function gerarSenhaSegura() {
            const tamanho = document.getElementById('tamanho_senha').value;
            
            try {
                const response = await fetch('/credenciais/gerar-senha', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                        'Accept': 'application/json',
                    },
                    body: JSON.stringify({ tamanho: parseInt(tamanho) })
                });
                
                if (response.ok) {
                    const data = await response.json();
                    document.getElementById('senha').value = data.senha;
                    
                    // Mostra feedback visual
                    const button = event.target;
                    const originalText = button.textContent;
                    button.textContent = 'Gerada!';
                    button.classList.remove('bg-green-500', 'hover:bg-green-700');
                    button.classList.add('bg-green-600');
                    
                    setTimeout(() => {
                        button.textContent = originalText;
                        button.classList.remove('bg-green-600');
                        button.classList.add('bg-green-500', 'hover:bg-green-700');
                    }, 2000);
                } else {
                    alert('Erro ao gerar a senha.');
                }
            } catch (error) {
                console.error('Erro:', error);
                alert('Erro ao gerar a senha.');
            }
        }
    </script>
</x-app-layout>