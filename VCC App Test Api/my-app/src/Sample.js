addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
  });
  
  // Global state
  let machineStatus = false;
  let rpmLevel = -1;
  let rotation = -1;
  let powerConsumption = 0;
  let powerInterval;
  
  async function handleRequest(request) {
    const url = new URL(request.url);
    const path = url.pathname;
    const queryParams = url.searchParams;
  
    let response;
    
    switch (path) {
      case '/info':
        response = new Response(JSON.stringify({ machineStatus, rpmLevel, rotation }), {
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
          },
        });
        break;
  
      case '/setstatus':
        machineStatus = queryParams.get('status') === 'true';
        rpmLevel = parseInt(queryParams.get('rpm'), 10);
        if (machineStatus) {
          startPowerConsumption(); // Start updating power consumption when status is true
        } else {
          resetParameters(); // Reset parameters when status is false
        }
        response = new Response(`Machine status set to ${machineStatus}`, {
          headers: { 
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
          },
        });
        break;
  
      case '/setrpm':
        rpmLevel = parseInt(queryParams.get('rpm'), 10);
        response = new Response(`RPM level set to ${rpmLevel}`, {
          headers: { 
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
          },
        });
        break;
  
      case '/setrotation':
        rotation = parseInt(queryParams.get('rot'), 10);
        response = new Response(`Rotation set to ${rotation}`, {
          headers: { 
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
          },
        });
        break;
  
      case '/powerconsumption':
        response = new Response(JSON.stringify({ powerConsumption }), {
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
          },
        });
        break;
  
      default:
        response = new Response('Not found', { 
          status: 404,
          headers: { 
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
          },
        });
        break;
    }
  
    return response;
  }
  
  function startPowerConsumption() {
    // Start updating power consumption if it's not already started
    if (!powerInterval) {
      powerInterval = setInterval(() => {
        powerConsumption = Math.floor(Math.random() * (600 - 500 + 1)) + 500; // Generates random number between 500 and 600
      }, 1000); // Update every second
    }
  }
  
  function resetParameters() {
    // Stop updating power consumption and reset parameters
    if (powerInterval) {
      clearInterval(powerInterval);
      powerInterval = null;
    }
    machineStatus = false;
    rpmLevel = 0;
    rotation = 0;
    powerConsumption = 0;
  }
  