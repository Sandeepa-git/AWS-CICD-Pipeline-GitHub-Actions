const request = require('supertest');
const app = require('../src/index');

describe('Application API Tests', () => {

  test('GET / should return welcome message', async () => {
    const response = await request(app).get('/');

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('Running');
  });

  test('GET /health should return healthy status', async () => {
    const response = await request(app).get('/health');

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('healthy');
  });

  test('GET /api/info should return application information', async () => {
    const response = await request(app).get('/api/info');

    expect(response.statusCode).toBe(200);
    expect(response.body.application).toBe('AWS CI/CD Project');
  });

});