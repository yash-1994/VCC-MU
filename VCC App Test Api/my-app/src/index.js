addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
    const url = new URL(request.url);
    const path = url.pathname;
    const queryParams = url.searchParams;

    let response;

    switch (path) {
        case '/info':
            response = await handleInfoRequest();
            break;

        case '/setstatus':
            response = await handleSetStatusRequest(queryParams);
            break;

        case '/setrpm':
            response = await handleSetRpmRequest(queryParams);
            break;

        case '/setrotation':
            response = await handleSetRotationRequest(queryParams);
            break;

        case '/powerconsumption':
            response = await handlePowerConsumptionRequest();
            break;

        case '/settemperature':
            response = await handleSetTemperatureRequest(queryParams);
            break;

        case '/temperature':
            response = await handleGetTemperatureRequest();
            break;

        default:
            response = new Response('Not found', {
                status: 404,
                headers: {
                    'Access-Control-Allow-Origin': '*',
                },
            });
            break;
    }

    return response;
}

async function handleInfoRequest() {
    const machineStatus = (await STATE.get('machineStatus')) === 'true' || false;
    const rpmLevel = parseInt(await STATE.get('rpmLevel'), 10) || 0;
    const rotation = parseInt(await STATE.get('rotation'), 10) || -1;
    const temperature = parseFloat(await STATE.get('temperature')) || 0.0;

    return new Response(JSON.stringify({ machineStatus, rpmLevel, rotation, temperature }), {
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
        },
    });
}

async function handleSetStatusRequest(queryParams) {
    const machineStatus = queryParams.get('status') === 'true';
    const rpmLevel = parseInt(queryParams.get('rpm'), 10) || 0;
    const rotation = parseInt(queryParams.get('rotation'), 10) || -1;

    await STATE.put('machineStatus', machineStatus.toString());
    await STATE.put('rpmLevel', rpmLevel.toString());
    await STATE.put('rotation', rotation.toString());

    if (machineStatus) {
        await startPowerConsumption();
    } else {
        await resetParameters();
    }

    return new Response(`Machine status set to ${machineStatus}`, {
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    });
}

async function handleSetRpmRequest(queryParams) {
    const rpmLevel = parseInt(queryParams.get('rpm'), 10) || 0;
    await STATE.put('rpmLevel', rpmLevel.toString());

    return new Response(`RPM level set to ${rpmLevel}`, {
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    });
}

async function handleSetRotationRequest(queryParams) {
    const rotation = parseInt(queryParams.get('rotation'), 10) || 0;
    await STATE.put('rotation', rotation.toString());

    return new Response(`Rotation set to ${rotation}`, {
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    });
}

async function handleSetTemperatureRequest(queryParams) {
    const temperature = parseFloat(queryParams.get('temperature')) || 0.0;
    await STATE.put('temperature', temperature.toString());

    return new Response(`Temperature set to ${temperature}`, {
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    });
}

async function handleGetTemperatureRequest() {
    const temperature = parseFloat(await STATE.get('temperature')) || 0.0;

    return new Response(JSON.stringify({ temperature }), {
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
        },
    });
}

async function handlePowerConsumptionRequest() {
    const powerConsumption = parseInt(await STATE.get('powerConsumption'), 10) || 0;

    return new Response(JSON.stringify({ powerConsumption }), {
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
        },
    });
}

async function startPowerConsumption() {
    if (!await STATE.get('powerInterval')) {
        await STATE.put('powerInterval', 'true');
        updatePowerConsumption();
    }
}

async function updatePowerConsumption() {
    while (await STATE.get('powerInterval') === 'true') {
        const powerConsumption = Math.floor(Math.random() * (600 - 500 + 1)) + 500;
        await STATE.put('powerConsumption', powerConsumption.toString());
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
}

async function resetParameters() {
    await STATE.put('powerInterval', 'false');
    await STATE.put('machineStatus', 'false');
    await STATE.put('rpmLevel', '0');
    await STATE.put('rotation', '-1');
    await STATE.put('powerConsumption', '0');
}
