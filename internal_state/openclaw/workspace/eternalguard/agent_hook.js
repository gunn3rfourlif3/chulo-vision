const engine = require('./core/safety_engine.js');
const testCase = "Ingozi! Gevaar! We need help.";
console.log("Chulo Heartbeat:", new Date().toISOString());
console.log("Test Scan:", engine.scan(testCase));
