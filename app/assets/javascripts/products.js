document.addEventListener('DOMContentLoaded', function() {
    // Função para adicionar um produto ao carrinho
    window.addToCart = async function(productId) {
      try {
        const response = await fetch(`/cart/add/${productId}`, { // Atualiza a URL para corresponder à rota
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: JSON.stringify({ qtde: 1 }) // Envia a quantidade, não é necessário enviar o id novamente aqui
        });
  
        const result = await response.json();
  
        if (response.ok) {
          alert(result.message); // Exibe mensagem de sucesso
        } else {
          alert(result.message); // Exibe mensagem de erro
        }
      } catch (error) {
        console.error('Erro ao adicionar ao carrinho:', error);
        alert('Ocorreu um erro ao adicionar o produto ao carrinho.');
      }
    };
  
    // Função para carregar a lista de produtos
    async function loadProducts() {
      try {
        const response = await fetch('/products', {
          headers: {
            'Accept': 'application/json' // Garante que o controlador reconheça a requisição como JSON
          }
        });
  
        if (response.headers.get('Content-Type').includes('application/json')) {
          const data = await response.json();
          if (data && data.status === 'success') {
            const productsList = document.getElementById('products-list');
            productsList.innerHTML = data.products.map(product => `
              <div>
                <h2>${product.name}</h2>
                <p>Preço: R$ ${product.price}</p>
                <button onclick="addToCart(${product.id})">Adicionar ao Carrinho</button>
              </div>
            `).join('');
  
            // Adiciona o botão "Ir ao Carrinho" ao final da lista de produtos
            const cartButton = document.createElement('button');
            cartButton.innerText = 'Ir ao Carrinho';
            cartButton.className = 'btn btn-primary';
            cartButton.onclick = function() {
              window.location.href = '/cart'; // Roteia para a página do carrinho
            };
            productsList.appendChild(cartButton);
          }
          
        } else {
          console.warn('A resposta não é JSON');
        }
      } catch (error) {
        console.error('Erro ao carregar os produtos:', error);
      }
    }
  
    // Carrega os produtos ao inicializar a página
    loadProducts();
  });
  