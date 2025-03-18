<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Profile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{

    public function login(Request $request)
    {
        $request->validate([
            'phone' => 'required',
            'password' => 'required',
        ]);

        $user = User::where('phone', $request->phone)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $token = $user->createToken('token_name')->plainTextToken;

        return response()->json(['token' => $token]);
    }
    public function register(Request $request)
    {
        $request->validate([
            'phone' => 'required|string|max:11',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        // Создание пользователя
        $user = User::create([
            'phone' => $request->phone,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        // Создание профиля и ассоциация с пользователем
        $profile = new Profile();
        $profile->name = 'Гость';
        $profile->user_id = $user->id; // Установка user_id
        $profile->save(); // Сохранение профиля

        return response()->json(['message' => $user]);
    }
}
