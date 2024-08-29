document.addEventListener('DOMContentLoaded', function() {
    // Acessar dados do HTML
    const profilePic = document.getElementById('profile-pic');
    const userRa = document.getElementById('user-ra');
    
    if (profilePic) {
        profilePic.src = profilePic.src;  // A URL da imagem já está definida no HTML
    }

    if (userRa) {
        // Usar o atributo data-ra para definir o texto
        userRa.textContent = userRa.getAttribute('data-ra');
    }

    // Adicionar funcionalidade ao botão de voltar
    const backButton = document.getElementById('back-button');
    if (backButton) {
        backButton.addEventListener('click', function() {
            window.location.href = '/users/products';  // Redireciona para a URL da tela de menu
        });
    }
});
