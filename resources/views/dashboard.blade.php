<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Gerenciador de Senhas Seguras') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <!-- Boas-vindas -->
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg mb-6">
                <div class="p-6 text-gray-900">
                    <h3 class="text-lg font-semibold mb-2">Bem-vindo, {{ auth()->user()->name }}!</h3>
                    <p class="text-gray-600">Gerencie suas credenciais de forma segura e organizada.</p>
                </div>
            </div>

            <!-- Estatísticas -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <div class="bg-blue-500 text-white p-6 rounded-lg shadow">
                    <div class="flex items-center">
                        <div class="text-3xl font-bold">{{ auth()->user()->credenciais()->count() }}</div>
                        <div class="ml-4">
                            <div class="text-sm opacity-75">Total de</div>
                            <div class="text-lg font-semibold">Credenciais</div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-green-500 text-white p-6 rounded-lg shadow">
                    <div class="flex items-center">
                        <div class="text-3xl font-bold">{{ auth()->user()->credenciais()->whereDate('created_at', today())->count() }}</div>
                        <div class="ml-4">
                            <div class="text-sm opacity-75">Criadas</div>
                            <div class="text-lg font-semibold">Hoje</div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-purple-500 text-white p-6 rounded-lg shadow">
                    <div class="flex items-center">
                        <div class="text-3xl font-bold">{{ auth()->user()->credenciais()->whereDate('updated_at', '>=', now()->subDays(7))->count() }}</div>
                        <div class="ml-4">
                            <div class="text-sm opacity-75">Atualizadas</div>
                            <div class="text-lg font-semibold">Esta Semana</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ações Rápidas -->
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg mb-6">
                <div class="p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Ações Rápidas</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <a href="{{ route('credenciais.create') }}" 
                           class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-4 px-6 rounded-lg text-center transition duration-200">
                            <div class="text-2xl mb-2">🔐</div>
                            <div>Nova Credencial</div>
                            <div class="text-sm opacity-75">Adicionar nova senha</div>
                        </a>
                        
                        <a href="{{ route('credenciais.index') }}" 
                           class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-4 px-6 rounded-lg text-center transition duration-200">
                            <div class="text-2xl mb-2">📋</div>
                            <div>Ver Credenciais</div>
                            <div class="text-sm opacity-75">Gerenciar senhas existentes</div>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Credenciais Recentes -->
            @if(auth()->user()->credenciais()->count() > 0)
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-lg font-semibold text-gray-900">Credenciais Recentes</h3>
                            <a href="{{ route('credenciais.index') }}" class="text-blue-500 hover:text-blue-700">Ver todas</a>
                        </div>
                        
                        <div class="space-y-3">
                            @foreach(auth()->user()->credenciais()->latest()->take(5)->get() as $credencial)
                                <div class="flex justify-between items-center p-3 bg-gray-50 rounded">
                                    <div>
                                        <div class="font-medium text-gray-900">{{ $credencial->nome_servico }}</div>
                                        <div class="text-sm text-gray-500">{{ $credencial->nome_usuario }}</div>
                                    </div>
                                    <div class="text-sm text-gray-400">
                                        {{ $credencial->created_at->diffForHumans() }}
                                    </div>
                                </div>
                            @endforeach
                        </div>
                    </div>
                </div>
            @else
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 text-center">
                        <div class="text-6xl mb-4">🔐</div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-2">Nenhuma credencial encontrada</h3>
                        <p class="text-gray-600 mb-4">Comece criando sua primeira credencial para manter suas senhas seguras.</p>
                        <a href="{{ route('credenciais.create') }}" 
                           class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                            Criar primeira credencial
                        </a>
                    </div>
                </div>
            @endif
        </div>
    </div>
</x-app-layout>
