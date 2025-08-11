<x-app-layout>
    <x-slot name="header">
        <div class="flex justify-between items-center">
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                {{ __('Minhas Credenciais') }}
            </h2>
            <a href="{{ route('credenciais.create') }}" 
               class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                Nova Credencial
            </a>
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <!-- Mensagens de sucesso -->
            @if (session('sucesso'))
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    {{ session('sucesso') }}
                </div>
            @endif
            
            <!-- Mensagens de erro -->
            @if (session('erro'))
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    {{ session('erro') }}
                </div>
            @endif

            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    @if($credenciais->count() > 0)
                        <div class="overflow-x-auto">
                            <table class="min-w-full table-auto">
                                <thead>
                                    <tr class="bg-gray-50">
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Serviço
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Usuário
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Senha
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Criado em
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Ações
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    @foreach($credenciais as $credencial)
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                {{ $credencial->nome_servico }}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                {{ $credencial->nome_usuario }}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <div class="flex items-center space-x-2">
                                                    <span class="text-gray-400">••••••••</span>
                                                    <button onclick="copiarSenha('{{ $credencial->id }}')"
                                                            class="bg-gray-500 hover:bg-gray-700 text-white text-xs px-2 py-1 rounded">
                                                        Copiar
                                                    </button>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                {{ $credencial->created_at->format('d/m/Y H:i') }}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <div class="flex space-x-2">
                                                    <a href="{{ route('credenciais.edit', $credencial) }}" 
                                                       class="text-indigo-600 hover:text-indigo-900">
                                                        Editar
                                                    </a>
                                                    <form action="{{ route('credenciais.destroy', $credencial) }}" method="POST" class="inline" onsubmit="return confirm('Tem certeza que deseja excluir esta credencial?')">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded text-sm">
                                            Excluir
                                        </button>
                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    @else
                        <div class="text-center py-8">
                            <div class="text-gray-500 text-lg mb-4">
                                Você ainda não possui credenciais cadastradas.
                            </div>
                            <a href="{{ route('credenciais.create') }}" 
                               class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                                Criar primeira credencial
                            </a>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript para copiar senha e excluir credencial -->
    <script>
        async function copiarSenha(credencialId) {
            try {
                const response = await fetch(`/credenciais/${credencialId}/obter-senha`, {
                    method: 'GET',
                    headers: {
                        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                        'Accept': 'application/json',
                    }
                });
                
                if (response.ok) {
                    const data = await response.json();
                    await navigator.clipboard.writeText(data.senha);
                    
                    // Mostra feedback visual
                    const button = event.target;
                    const originalText = button.textContent;
                    button.textContent = 'Copiado!';
                    button.classList.remove('bg-gray-500', 'hover:bg-gray-700');
                    button.classList.add('bg-green-500');
                    
                    setTimeout(() => {
                        button.textContent = originalText;
                        button.classList.remove('bg-green-500');
                        button.classList.add('bg-gray-500', 'hover:bg-gray-700');
                    }, 2000);
                } else {
                    alert('Erro ao obter a senha.');
                }
            } catch (error) {
                console.error('Erro:', error);
                alert('Erro ao copiar a senha.');
            }
        }


    </script>
</x-app-layout>