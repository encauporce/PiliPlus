//!HOOK POSTKERNEL
//!BIND HOOKED
//!DESC Zero-Moire Halftone with Text Protection (Style 2: Inverted Paper Print)

// ============================================================
// 🛠️【文字保护与风格调节区】
// ============================================================
#define TEXT_PROTECT        1      // 文字与字幕锐化保护：1 开启，0 关闭
#define TEXT_STYLE          2      // 风格 2：纸质印刷反转风（暗底白字转为纯净白纸黑字，适合看代码/网课/录屏）
#define DOT_DENSITY         0.65   // 场景网点浓密度：0.65（清爽透气）
#define DARK_LIFT           0.65   // 暗部细节提亮：0.65（针对夜戏与暗调场景）
#define LINE_WIDTH          1.0    // 描边轮廓粗细：1.0
#define LINE_SENSITIVITY    3.2    // 描边灵敏度：3.2
#define LINE_THRESHOLD      0.06   // 描边杂纹过滤
// ============================================================

float get_luma_at(vec2 pos) {
    vec4 c = HOOKED_tex(pos);
    return dot(c.rgb, vec3(0.299, 0.587, 0.114));
}

// 工业级 4x4 印刷聚簇网点矩阵（绝对整数像素对齐，100% 根除摩尔纹）
float get_clustered_threshold(ivec2 px) {
    int x = px.x % 4;
    int y = px.y % 4;
    if (x < 0) x += 4;
    if (y < 0) y += 4;
    
    const float m[16] = float[16](
        12.0,  8.0,  9.0, 13.0,
         7.0,  0.0,  1.0,  5.0,
         6.0,  2.0,  3.0,  4.0,
        11.0, 10.0, 14.0, 15.0
    );
    return (m[y * 4 + x] + 0.5) / 16.0;
}

vec4 hook() {
    vec2 pt = HOOKED_pt * LINE_WIDTH;
    
    // 1. 3x3 空间采样
    float c  = get_luma_at(HOOKED_pos);
    float tl = get_luma_at(HOOKED_pos + vec2(-pt.x, -pt.y));
    float t  = get_luma_at(HOOKED_pos + vec2( 0.0,  -pt.y));
    float tr = get_luma_at(HOOKED_pos + vec2( pt.x, -pt.y));
    float l  = get_luma_at(HOOKED_pos + vec2(-pt.x,  0.0));
    float r  = get_luma_at(HOOKED_pos + vec2( pt.x,  0.0));
    float bl = get_luma_at(HOOKED_pos + vec2(-pt.x,  pt.y));
    float b  = get_luma_at(HOOKED_pos + vec2( 0.0,   pt.y));
    float br = get_luma_at(HOOKED_pos + vec2( pt.x,  pt.y));
    
    // 2. Scharr 轮廓检测
    float gx = (3.0 * tr + 10.0 * r + 3.0 * br) - (3.0 * tl + 10.0 * l + 3.0 * bl);
    float gy = (3.0 * bl + 10.0 * b + 3.0 * br) - (3.0 * tl + 10.0 * t + 3.0 * tr);
    float mag = length(vec2(gx, gy)) * (LINE_SENSITIVITY / 32.0);
    float is_line = smoothstep(LINE_THRESHOLD, LINE_THRESHOLD + 0.14, mag);
    
    // 3. 局部极值与高频反差
    float min_luma = min(c, min(min(tl, t), min(tr, min(l, min(r, min(bl, min(b, br)))))));
    float max_luma = max(c, max(max(tl, t), max(tr, max(l, max(r, max(bl, max(b, br)))))));
    float local_contrast = max_luma - min_luma;
    
    // 4. 自然场景半色调网点
    float lifted_luma = mix(c, sqrt(c), DARK_LIFT);
    ivec2 screen_px = ivec2(HOOKED_pos / HOOKED_pt);
    float thresh = get_clustered_threshold(screen_px);
    
    float shadow_factor = clamp(1.0 - lifted_luma, 0.0, 1.0);
    float dot_prob = pow(shadow_factor, 1.4) * DOT_DENSITY;
    float is_dot = (dot_prob > thresh) ? 1.0 : 0.0;
    
    float result = 1.0 - is_dot;
    result = min(result, 1.0 - is_line);
    
    // 5. 风格 2：纸质印刷反转风
    #if TEXT_PROTECT == 1
    if (local_contrast > 0.28) {
        float mid_thresh = min_luma + 0.45 * local_contrast;
        bool is_bright_core = (c > mid_thresh && max_luma > 0.48);
        bool is_dark_core   = (c <= mid_thresh && min_luma < 0.42);
        
        // 暗底白字转为纯净白纸黑字（文字实心黑，背景纯白纸面）
        if (is_bright_core) {
            result = 0.0; // 文字笔画反转为浓黑墨线
        } else {
            result = 1.0; // 背景完全留白为纯白宣纸，杜绝噪点
        }
        if (is_dark_core && max_luma > 0.65) {
            result = 0.0;
        }
    }
    #endif
    
    return vec4(vec3(result), 1.0);
}
