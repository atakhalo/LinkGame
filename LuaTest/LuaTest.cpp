// LuaTest.cpp: 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include<iostream>
#include<lua.hpp>
//#include<string>
//#include<vector>

#pragma comment(lib, "Lua5.3.4.lib")

using namespace std;
	
int main()
{
	string a;
	char buff[256];
	int error;
	int raw = 6, col = 6, mul = 4;
	cout << "排数(raw):" << flush;
	cin >> raw;
	cout << "行数(col):" << flush;
	cin >> col;
	cout << "倍数(mul):" << flush;
	cin >> mul;
	lua_State *l = luaL_newstate();
	luaL_openlibs(l);
	luaL_dofile(l, "main.lua");
	lua_getglobal(l, "createMap");
	lua_pushnumber(l, raw);
	lua_pushnumber(l, col);
	lua_pushnumber(l, mul);
	if (lua_pcall(l, 3, 0, 0) != 0)
		printf("error running function 'createMap' : %s", lua_tostring(l, -1));
	//luaL_dofile(l, "main.lua");
	lua_getglobal(l, "randomMap");
	lua_pushnumber(l, 100);
	if (lua_pcall(l, 1, 0, 0) != 0)
		printf("error running function 'randomMap' : %s", lua_tostring(l, -1));
	lua_getglobal(l, "printMap");
	if (lua_pcall(l, 0, 0, 0) != 0)
		printf("error running function 'printMap' : %s", lua_tostring(l, -1));
	while(1)
	{
		int ar, ac, br, bc;
		cout << "第一个数的排(r):" << flush;
		cin >> ar;
		cout << "第一个数的行(c):" << flush;
		cin >> ac;
		//scanf_s("%d,%d", &ar, &ac);
		cout << "第二个数的排(r):" << flush;
		cin >> br;
		cout << "第二个数的行(c):" << flush;
		cin >> bc;
		//scanf_s("%d,%d", &br, &bc);
		lua_getglobal(l, "updateMap");
		lua_pushnumber(l, ar);
		lua_pushnumber(l, ac);
		lua_pushnumber(l, br);
		lua_pushnumber(l, bc);
		if (lua_pcall(l, 4, 1, 0) != 0)
			printf("error running function 'updateMap' : %s", lua_tostring(l, -1));
		if (lua_toboolean(l, -1))
			;//cout << "kill success!";
		else
			;
			//cout << "fail!";
		lua_getglobal(l, "printMap");
		if (lua_pcall(l, 0, 0, 0) != 0)
			printf("error running function 'printMap' : %s", lua_tostring(l, -1));
		lua_getglobal(l, "overMap");
		if (lua_pcall(l, 0, 1, 0) != 0)
			printf("error running function 'overMap' : %s", lua_tostring(l, -1));
		if (lua_toboolean(l, -1))
		{
			cout << "congratulations!" << endl;
			break;
		}
	}
	lua_close(l);	
	system("pause");
	
    return 0;	
}

