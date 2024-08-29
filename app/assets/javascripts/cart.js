document.addEventListener('DOMContentLoaded', function() {
    const cartContent = document.getElementById('cart-content');
    const clearCartForm = document.getElementById('clear-cart-form');

    // Função para esvaziar o carrinho
    async function clearCart() {
        try {
            const response = await fetch(clearCartForm.action, {
                method: clearCartForm.method,
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                }
            });

            const result = await response.json();

            if (response.ok) {
                window.location.href = '/users/products'; // Redireciona após limpar o carrinho
            } else {
                alert('Erro ao limpar o carrinho');
            }
        } catch (error) {
            console.error('Erro ao esvaziar o carrinho:', error);
            alert('Erro ao limpar o carrinho');
        }
    }

    // Adiciona o listener ao formulário de limpeza do carrinho
    if (clearCartForm) {
        clearCartForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Evita o comportamento padrão do formulário
            clearCart(); // Chama a função de limpeza
        });
    }
});
