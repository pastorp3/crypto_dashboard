document.addEventListener('DOMContentLoaded', function () {
  const tradeButton = document.getElementById('trade-button');
  const tradeForm = document.getElementById('trade-form');
  const coinsTabButton = document.getElementById('coins-tab-button');
  const walletTabButton = document.getElementById('wallet-tab-button');
  const coinsTab = document.getElementById('coins-tab');
  const walletTab = document.getElementById('wallet-tab');

  tradeButton.addEventListener('click', function () {
    tradeForm.style.display = tradeForm.style.display === 'none' ? 'block' : 'none';
  });

  const calculateButton = document.getElementById('calculate-button');
  calculateButton.addEventListener('click', function () {
    const coinSelect = document.getElementById('coin-select');
    const quantityInput = document.getElementById('quantity-input');
    const resultContainer = document.getElementById('result-container');

    const coin = coinSelect.value;
    const quantity = quantityInput.value;

    fetch(`/calculator?coin=${coin}&quantity=${quantity}`)
      .then(response => response.json())
      .then(data => {
        if ( data.error) {
          resultContainer.innerHTML = `
          <p class="mt-3">${data.error}</p>
        `;
        } else {
          resultContainer.innerHTML = `
            <p class="mt-3">Annual Profit in ${coin}: ${data.coin}</p>
            <p>Dollars Profit: ${data.value}</p>
          `;
        }
      })
      .catch(error => console.error('Error:', error));
  });

  function switchTab(tabButton, tabContent, activeClass, inactiveClass) {

    tabContent.style.display = 'block';
    const otherTab = tabButton === coinsTabButton ? walletTab : coinsTab;
    otherTab.style.display = 'none';

    tabButton.classList.add(activeClass);
    tabButton.classList.remove(inactiveClass);

    const otherTabButton = tabButton === coinsTabButton ? walletTabButton : coinsTabButton;
    otherTabButton.classList.add(inactiveClass);
    otherTabButton.classList.remove(activeClass);
  }

  coinsTabButton.addEventListener('click', function () {
    switchTab(coinsTabButton, coinsTab, 'btn-primary', 'btn-secondary');
  });

  walletTabButton.addEventListener('click', function () {
    switchTab(walletTabButton, walletTab, 'btn-primary', 'btn-secondary');
    updateWalletInvestment();
  });

  coinsTabButton.click();

  const investButton = document.getElementById('invest-button');
  investButton.addEventListener('click', function () {
    const coinSelect = document.getElementById('coin-select');
    const quantityInput = document.getElementById('quantity-input');
    const resultContainer = document.getElementById('result-container');
    const coin = coinSelect.value;
    const quantity = quantityInput.value;

    fetch('/invest', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ coin, quantity }),
    })
      .then(response => response.json())
      .then(data => {
        if ( data.error) {
          resultContainer.innerHTML = `
          <p class="mt-3">${data.error}</p>
        `;} else {
          resultContainer.innerHTML = `
          <p class="mt-3">Investment successful!</p>
        `;}
        
        updateWalletInvestment();
      })
      .catch(error => console.error('Investment error:', error));
  });

  function updateWalletInvestment() {
    fetch('/wallet_investment')
      .then(response => response.json())
      .then(data => {
        updateInvestment('btc', data.btc_investment, data.btc_value);
        updateInvestment('eth', data.eth_investment, data.eth_value);
        updateInvestment('ada', data.ada_investment, data.ada_value);
      })
      .catch(error => console.error('Wallet investment error:', error));
  }

  function updateInvestment(coin, investment, value) {
    const investmentElement = document.getElementById(`${coin}-investment`);
    const valueElement = document.getElementById(`${coin}-value`);
    const totalInvestmentElement = document.getElementById(`${coin}-investment-total`);

    investmentElement.textContent = investment;
    totalInvestmentElement.textContent = `$${valueElement.textContent.split(' ')[1] * investment}`;
  }

  const coinsTabDownloadCsvButton = document.getElementById('coins-download-csv');
  const coinsTabDownloadJsonButton = document.getElementById('coins-download-json');
  const walletTabDownloadCsvButton = document.getElementById('wallet-download-csv');
  const walletTabDownloadJsonButton = document.getElementById('wallet-download-json');

  function getTabData(tab) {
    const tabData = {};
    const btcValue = parseFloat(document.getElementById('btc-value').textContent.split(' ')[1]);
    const ethValue = parseFloat(document.getElementById('eth-value').textContent.split(' ')[1]);
    const adaValue = parseFloat(document.getElementById('ada-value').textContent.split(' ')[1]);

    if (tab === 'coins') {
      tabData['Bitcoin'] = { value: btcValue };
      tabData['Ether'] = { value: ethValue };
      tabData['Cardano'] = { value: adaValue };
    } else {
      const btcInvestment = parseFloat(document.getElementById('btc-investment').textContent);
      const ethInvestment = parseFloat(document.getElementById('eth-investment').textContent);
      const adaInvestment = parseFloat(document.getElementById('ada-investment').textContent);

      tabData['Bitcoin'] = { value: btcValue, investment: btcInvestment, investment_value: btcValue * btcInvestment };
      tabData['Ether'] = { value: ethValue, investment: ethInvestment, investment_value: ethValue * ethInvestment };
      tabData['Cardano'] = { value: adaValue, investment: adaInvestment, investment_value: adaValue * adaInvestment };
    }

    return tabData;
  }

  coinsTabDownloadCsvButton.addEventListener('click', function () {
    downloadData('/wallet/download_data', { tab: 'coins', type: 'csv', data: getTabData('coins') });
  });

  coinsTabDownloadJsonButton.addEventListener('click', function () {
    downloadData('/wallet/download_data', { tab: 'coins', type: 'json', data: getTabData('coins') });
  });

  walletTabDownloadCsvButton.addEventListener('click', function () {
    downloadData('/wallet/download_data', { tab: 'wallet', type: 'csv', data: getTabData('wallet') });
  });

  walletTabDownloadJsonButton.addEventListener('click', function () {
    downloadData('/wallet/download_data', { tab: 'wallet', type: 'json', data: getTabData('wallet') });
  });

  function downloadData(endpoint, params) {
    fetch(buildUrl(endpoint, params))
      .then(response => response.blob())
      .then(blob => {
        const url = window.URL.createObjectURL(new Blob([blob]));
        const a = document.createElement('a');
        a.href = url;
        a.download = `${params.tab}.${params.type}`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
      })
      .catch(error => console.error('Download error:', error));
  }

  function buildUrl(endpoint, params) {
    const url = new URL(endpoint, window.location.origin);
    Object.keys(params).forEach(key => url.searchParams.append(key, JSON.stringify(params[key])));
    return url;
  }
});