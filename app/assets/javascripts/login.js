async function login() {
    const ra = document.getElementById('ra').value;
    const senha = document.getElementById('senha').value;
    const errorMessage = document.getElementById('error-message');
    const successMessage = document.getElementById('success-message');

    try {
        const response = await fetch('/login', { // Substitua com a URL correta se necessário
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({
                user:{
                    ra: ra,
                    senha: senha
                }
            })
        });

        const result = await response.json();

        console.log('Response JSON:', result); // Adicione este log para depuração

        if (response.ok) {
            // Exibindo a mensagem de sucesso
            successMessage.textContent = result.message;
            successMessage.style.display = 'block';
            errorMessage.style.display = 'none';

            // Redirecionando com base no tipo de usuário
            if (result.user_type === "admin") {
                console.log('Redirecionando para admin_dashboard'); // Adicione este log para depuração
                window.location.href = '/admin_dashboard'; // Substitua pela URL correta para admin
            } else if (result.user_type === "user") {
                console.log('Redirecionando para products'); // Adicione este log para depuração
                window.location.href = '/users/products'; // Substitua pela URL correta para a página de produtos
            }
        } else {
            // Exibindo a mensagem de erro
            errorMessage.textContent = result.message || 'Erro ao fazer login. Verifique suas credenciais.';
            errorMessage.style.display = 'block';
            successMessage.style.display = 'none';
        }
    } catch (error) {
        console.error('Erro:', error);
        errorMessage.textContent = 'Erro ao fazer login. Tente novamente.';
        errorMessage.style.display = 'block';
        successMessage.style.display = 'none';
    }
}

// Adiciona um listener ao formulário para chamar a função login
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('login-form').addEventListener('submit', function(event) {
        event.preventDefault(); // Impede o envio padrão do formulário
        login(); // Chama a função de login
    });
});
