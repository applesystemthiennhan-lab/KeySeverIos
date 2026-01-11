#include "imgui.h"
#import "AuthSystem.h"

static float remaining_time = 90.0f; 
static char key_buf[128] = "";
static bool is_auth_done = false;

void RenderMainUI() {
    if (is_auth_done) return;

    remaining_time -= ImGui::GetIO().DeltaTime;
    if (remaining_time <= 0) exit(0);

    ImGui::SetNextWindowSize(ImVec2(360, 420));
    ImGui::Begin("SecureAuth", NULL, ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_NoBackground);
    
    ImVec2 p = ImGui::GetWindowPos();
    ImVec2 s = ImGui::GetWindowSize();
    ImDrawList* draw = ImGui::GetWindowDrawList();

    draw->AddRectFilled(p, ImVec2(p.x + s.x, p.y + s.y), IM_COL32(30, 30, 35, 230), 35.0f);

    ImVec2 center = ImVec2(p.x + s.x * 0.5f, p.y + 80);
    float rotate = (float)ImGui::GetTime() * -3.0f;
    draw->PathArcTo(center, 52, rotate, rotate + 4.5f, 60);
    draw->PathStroke(IM_COL32(0, 255, 255, 255), false, 4.5f);

    ImGui::SetCursorPosY(155);
    char timer_str[64]; sprintf(timer_str, "App sẽ văng sau: %.0fs", remaining_time);
    ImGui::SetCursorPosX((s.x - ImGui::CalcTextSize(timer_str).x) * 0.5f);
    ImGui::TextColored(ImVec4(1.0f, 0.4f, 0.4f, 1.0f), "%s", timer_str);

    ImGui::SetCursorPosY(185);
    float tw = ImGui::CalcTextSize("Enter API Key").x;
    ImGui::SetCursorPosX((s.x - tw) * 0.5f);
    ImGui::TextDisabled("Enter API Key");

    ImGui::SetCursorPosY(225);
    ImGui::SetCursorPosX(s.x * 0.1f);
    ImGui::PushItemWidth(s.x * 0.8f);
    ImGui::InputTextWithHint("##keyinput", "Dán Key vào đây...", key_buf, 128);
    ImGui::PopItemWidth();

    ImGui::SetCursorPosY(320);
    ImGui::SetCursorPosX(s.x * 0.1f);
    if (ImGui::Button("Paste Key", ImVec2(150, 60))) {
        NSString *clip = [UIPasteboard generalPasteboard].string;
        if (clip) {
            strncpy(key_buf, [clip UTF8String], 127);
            [AuthSystem verifyKey:clip];
        }
    }
    
    ImGui::SameLine(s.x * 0.56f);
    if (ImGui::Button("Help", ImVec2(115, 60))) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://getudidv3.2bd.net/huongdan/huongdan.html"] options:@{} completionHandler:nil];
    }
    ImGui::End();
}
