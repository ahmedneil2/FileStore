from aiohttp import web

routes = web.RouteTableDef()

@routes.get("/", allow_head=True)
async def root_route_handler(request):
    return web.json_response({
        "status": "ok",
        "message": "Codeflix FileStore Bot is running!",
        "version": "1.0.0"
    })

@routes.get("/health", allow_head=True)
async def health_check_handler(request):
    return web.json_response({
        "status": "healthy",
        "timestamp": str(request.loop.time())
    })
