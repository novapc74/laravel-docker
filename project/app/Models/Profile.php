<?php

namespace App\Models;

use JetBrains\PhpStorm\ArrayShape;
use Illuminate\Database\Query\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Post
 *
 * @mixin Builder
 */
class Profile extends Model
{
    /** @use HasFactory<\Database\Factories\ProfileFactory> */
    use HasFactory;

    use HasUuids;

    /**
     * Тип данных автоинкрементного идентификатора.
     *
     * @var string
     */
    protected $keyType = 'string';

    /**
     * Атрибуты, для которых разрешено массовое присвоение значений.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'birthday',
        'gender',
    ];

    #[ArrayShape([
        'Мужской' => 'integer',
        'Женский' => 'integer',
    ])]
    protected static function getAvailableGenderType(?bool $isflip = false): array
    {
        $data = [
            'Мужской' => 1,
            'Женский' => 2,
        ];

        return $isflip ? array_flip($data) : $data;
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public static function getAuthUser(User $user): ?Profile
    {
        return Profile::where('user_id', $user->id)?->first();
    }
}
