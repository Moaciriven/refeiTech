document.addEventListener('DOMContentLoaded', function() {
    const userList = document.getElementById('user-list');
    const addUserForm = document.getElementById('add-user-form');

    // Função para carregar a lista de usuários
    async function loadUsers() {
        try {
            const response = await fetch('/admin/users');
            const result = await response.json();
            if (response.ok) {
                renderUsers(result.users);
            } else {
                console.error(result.message);
            }
        } catch (error) {
            console.error('Erro ao carregar usuários:', error);
        }
    }

    // Função para renderizar a lista de usuários
    function renderUsers(users) {
        userList.innerHTML = '';
        users.forEach(user => {
            const listItem = document.createElement('li');
            listItem.innerHTML = `
                ${user.name} - ${user.email}
                <button class="remove-button" data-id="${user.ra}">Remover</button>
            `;
            userList.appendChild(listItem);
        });

        // Adiciona evento de clique aos botões de remover
        document.querySelectorAll('.remove-button').forEach(button => {
            button.addEventListener('click', function() {
                removeUser(this.getAttribute('data-id'));
            });
        });
    }

    // Função para adicionar um novo usuário
    addUserForm.addEventListener('submit', async function(event) {
        event.preventDefault();
        const formData = new FormData(addUserForm);
        const data = {};
        formData.forEach((value, key) => { data[key] = value });

        try {
            const response = await fetch('/admin/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(data)
            });
            const result = await response.json();
            if (response.ok) {
                alert(result.message);
                loadUsers(); // Atualiza a lista de usuários
            } else {
                alert(result.message);
            }
        } catch (error) {
            console.error('Erro ao adicionar usuário:', error);
        }
    });

    // Função para remover um usuário
    async function removeUser(userId) {
        try {
            const response = await fetch(`/admin/users/${userId}`, { method: 'DELETE' });
            const result = await response.json();
            if (response.ok) {
                alert(result.message);
                loadUsers(); // Atualiza a lista de usuários
            } else {
                alert(result.errors);
            }
        } catch (error) {
            console.error('Erro ao remover usuário:', error);
        }
    }

    // Carrega a lista de usuários ao inicializar a página
    loadUsers();

    document.getElementById('back-button').addEventListener('click', function() {
        window.location.href = '/';  // Redireciona para a página inicial
    });
});
