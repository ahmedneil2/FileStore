#!/usr/bin/env python3
"""
Simple test script to verify FileStore bot deployment
"""

import asyncio
import aiohttp
import os
from config import *

async def test_web_server():
    """Test if web server is running"""
    try:
        port = int(os.environ.get("PORT", "8001"))
        url = f"http://localhost:{port}/"
        
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                if response.status == 200:
                    data = await response.json()
                    print(f"✅ Web server is running: {data}")
                    return True
                else:
                    print(f"❌ Web server returned status: {response.status}")
                    return False
    except Exception as e:
        print(f"❌ Web server test failed: {e}")
        return False

async def test_health_endpoint():
    """Test health check endpoint"""
    try:
        port = int(os.environ.get("PORT", "8001"))
        url = f"http://localhost:{port}/health"
        
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                if response.status == 200:
                    data = await response.json()
                    print(f"✅ Health check passed: {data}")
                    return True
                else:
                    print(f"❌ Health check failed with status: {response.status}")
                    return False
    except Exception as e:
        print(f"❌ Health check test failed: {e}")
        return False

def test_environment_variables():
    """Test if required environment variables are set"""
    required_vars = [
        "TG_BOT_TOKEN",
        "APP_ID", 
        "API_HASH",
        "CHANNEL_ID",
        "OWNER_ID",
        "DATABASE_URL",
        "DATABASE_NAME"
    ]
    
    missing_vars = []
    for var in required_vars:
        if not os.environ.get(var):
            missing_vars.append(var)
    
    if missing_vars:
        print(f"❌ Missing environment variables: {', '.join(missing_vars)}")
        return False
    else:
        print("✅ All required environment variables are set")
        return True

async def test_database_connection():
    """Test database connection"""
    try:
        from database.database import Database
        db = Database(DATABASE_URL, DATABASE_NAME)
        # Simple test - this will create connection
        await db.total_users_count()
        print("✅ Database connection successful")
        return True
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        return False

async def main():
    """Run all tests"""
    print("🚀 Starting FileStore Bot Deployment Tests\n")
    
    tests = [
        ("Environment Variables", test_environment_variables),
        ("Database Connection", test_database_connection),
        ("Web Server", test_web_server),
        ("Health Endpoint", test_health_endpoint)
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"Running {test_name} test...")
        if asyncio.iscoroutinefunction(test_func):
            result = await test_func()
        else:
            result = test_func()
        results.append((test_name, result))
        print()
    
    print("📊 Test Results:")
    print("-" * 40)
    passed = 0
    for test_name, result in results:
        status = "PASS" if result else "FAIL"
        print(f"{test_name}: {status}")
        if result:
            passed += 1
    
    print(f"\n✅ {passed}/{len(tests)} tests passed")
    
    if passed == len(tests):
        print("🎉 All tests passed! Your bot is ready to use.")
    else:
        print("⚠️  Some tests failed. Please check the configuration.")

if __name__ == "__main__":
    asyncio.run(main())
