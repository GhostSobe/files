local a = getscriptbytecode
local b = base64.encode
local c = request
local d = game:GetService("HttpService")
local e = game:GetService("UserInputService")

local f = table.find({ Enum.Platform.IOS, Enum.Platform.Android }, e:GetPlatform())

local function decompile(g)
	local h = c({
		Url = "https://production-test.seriality.ai/api/v1/decompiles/decompile",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			Authorization = "Androssy",
		},
		Body = d:JSONEncode({
			script = b(a(g)),
		}),
	})

	return h.StatusCode == 200 and h.Body or "Failed to decompile"
end

getgenv().decompile = decompile

local g = {}
local h
local i = cloneref or function(...)
	return ...
end

if not isfile("classes.png") then
	writefile("classes.png", game:HttpGet("https://androssy.net/images/ClassImages.png"))
end

local j = f and getcustomasset("classes.png") or "rbxasset://textures/ClassImages.png"

warn("classimages", j, getcustomasset("classes.png"))

local aa = {
	Explorer = function()
		local k, l, m, n
		local o, p, q, r
		local s, t, u, v, w, x, y

		local function initDeps(z)
			k = z.Main
			l = z.Lib
			m = z.Apps
			n = z.Settings

			s = z.API
			t = z.RMD
			u = z.env
			v = z.service
			w = z.plr
			x = z.create
			y = z.createSimple
		end

		local function initAfterMain()
			o = m.Explorer
			p = m.Properties
			q = m.ScriptViewer
			r = m.Notebook
		end

		local function main()
			local z = {}
			local A, B, C, D, E = {}, {}, {}, {}, {}
			local F
			local G, H, I, J, K, L
			local M = game.FindFirstAncestorWhichIsA
			local N = game.GetDescendants
			local O = v.TextService.GetTextSize
			local P, Q = false, false
			local R = { Obj = Instance.new("Folder") }
			local S = 0
			local T, U, V
			local W, X, Y
			local Z, _
			local aa, ab = table, math
			local ac, ad = {}, {}
			local ae = game.DescendantAdded.Connect
			local af, ag, ah

			af = function(ai)
				if g[ai] then
					return
				end

				local aj = false
				local ak = M(ai, "Instance")
				local al = g[ak]

				if not al then
					if ac[ai] then
						ad[ai] = ad[ai] or {
							ae(ai.ChildAdded, af),
							ae(ai.AncestryChanged, ah),
						}
						al = R
						aj = true
					else
						return
					end
				elseif ac[ak] or al == R then
					ac[ai] = true
					ad[ai] = ad[ai] or {
						ae(ai.ChildAdded, af),
						ae(ai.AncestryChanged, ah),
					}
					aj = true
				end

				local am = { Obj = ai, Parent = al }
				g[ai] = am

				if Z and F[al] and al.Sorted then
					local an, ao = 1, #al
					local ap = ab.floor
					local aq = z.NodeSorter
					local ar = (ao == 0 and 1)

					if not ar then
						while true do
							if an >= ao then
								if aq(am, al[an]) then
									ar = an
								else
									ar = an + 1
								end
								break
							end

							local as = ap((an + ao) / 2)
							if aq(am, al[as]) then
								ao = as - 1
							else
								an = as + 1
							end
						end
					end

					aa.insert(al, ar, am)
				else
					al[#al + 1] = am
					al.Sorted = nil
				end

				local an = N(ai)
				for ao = 1, #an do
					local ap = an[ao]
					if g[ap] then
						continue
					end

					local aq = g[M(ap, "Instance")]
					if not aq then
						continue
					end
					local ar = { Obj = ap, Parent = aq }
					g[ap] = ar
					aq[#aq + 1] = ar

					if aj then
						ac[ap] = true
						ad[ap] = ad[ap] or {
							ae(ap.ChildAdded, af),
							ae(ap.AncestryChanged, ah),
						}
					end
				end

				if Y and _ then
					Y({ am })
				end

				if not P and z.IsNodeVisible(al) then
					if F[al] then
						z.PerformUpdate()
					elseif not Q then
						z.PerformRefresh()
					end
				end
			end

			ag = function(ai)
				local aj = g[ai]
				if not aj then
					return
				end

				if ac[aj.Obj] then
					ah(aj.Obj)
					return
				end

				local ak = aj.Parent
				if ak then
					ak.HasDel = true
				end

				local function recur(al)
					for am = 1, #al do
						local an = al[am]
						if not an.Del then
							g[an.Obj] = nil
							if #an > 0 then
								recur(an)
							end
						end
					end
				end
				recur(aj)
				aj.Del = true
				g[ai] = nil

				if ak and not P and z.IsNodeVisible(ak) then
					if F[ak] then
						z.PerformUpdate()
					elseif not Q then
						z.PerformRefresh()
					end
				end
			end

			ah = function(ai)
				local aj = g[ai]
				if not aj then
					return
				end

				local ak = aj.Parent
				local al = g[M(ai, "Instance")]
				if ak == al then
					return
				end

				if not al then
					if ac[ai] then
						al = R
					else
						return
					end
				elseif ac[al.Obj] or al == R then
					ac[ai] = true
					ad[ai] = ad[ai] or {
						ae(ai.ChildAdded, af),
						ae(ai.AncestryChanged, ah),
					}
				end

				if ak then
					local am = aa.find(ak, aj)
					if am then
						aa.remove(ak, am)
					end
				end

				aj.Id = nil
				aj.Parent = al

				if Z and F[al] and al.Sorted then
					local am, an = 1, #al
					local ao = ab.floor
					local ap = z.NodeSorter
					local aq = (an == 0 and 1)

					if not aq then
						while true do
							if am >= an then
								if ap(aj, al[am]) then
									aq = am
								else
									aq = am + 1
								end
								break
							end

							local ar = ao((am + an) / 2)
							if ap(aj, al[ar]) then
								an = ar - 1
							else
								am = ar + 1
							end
						end
					end

					aa.insert(al, aq, aj)
				else
					al[#al + 1] = aj
					al.Sorted = nil
				end

				if Y and D[aj] then
					local am = aj.Parent
					while am and (not D[am] or F[am] == 0) do
						F[am] = true
						D[am] = true
						am = am.Parent
					end
				end

				if not P and (z.IsNodeVisible(al) or z.IsNodeVisible(ak)) then
					if F[al] or F[ak] then
						z.PerformUpdate()
					elseif not Q then
						z.PerformRefresh()
					end
				end
			end

			z.ViewWidth = 0
			z.Index = 0
			z.EntryIndent = 20
			z.FreeWidth = 32
			z.GuiElems = {}

			z.InitRenameBox = function()
				W = x({ { 1, "TextBox", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderColor3 = Color3.new(0.062745101749897, 0.51764708757401, 1), BorderMode = 2, ClearTextOnFocus = false, Font = 3, Name = "RenameBox", PlaceholderColor3 = Color3.new(0.69803923368454, 0.69803923368454, 0.69803923368454), Position = UDim2.new(0, 26, 0, 2), Size = UDim2.new(0, 200, 0, 16), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 0, Visible = false, ZIndex = 2 } } })

				W.Parent = z.Window.GuiElems.Content.List

				W.FocusLost:Connect(function()
					if not X then
						return
					end

					pcall(function()
						X.Obj.Name = W.Text
					end)
					X = nil
					z.Refresh()
				end)

				W.Focused:Connect(function()
					W.SelectionStart = 1
					W.CursorPosition = #W.Text + 1
				end)
			end

			z.SetRenamingNode = function(ai)
				X = ai
				W.Text = tostring(ai.Obj)
				W:CaptureFocus()
				z.Refresh()
			end

			z.SetSortingEnabled = function(ai)
				Z = ai
				n.Explorer.Sorting = ai
			end

			z.UpdateView = function()
				local ai = ab.ceil(H.AbsoluteSize.Y / 20)
				local aj = H.AbsoluteSize.X
				local ak = z.ViewWidth + z.FreeWidth

				T.VisibleSpace = ai
				T.TotalSpace = #A + 1
				U.VisibleSpace = aj
				U.TotalSpace = ak

				T.Gui.Visible = #A + 1 > ai
				U.Gui.Visible = ak > aj

				local al = H.Size
				H.Size = UDim2.new(1, (T.Gui.Visible and -16 or 0), 1, (U.Gui.Visible and -39 or -23))
				if al ~= H.Size then
					z.UpdateView()
				else
					T:Update()
					U:Update()

					W.Size = UDim2.new(0, aj - 100, 0, 16)

					if T.Gui.Visible and U.Gui.Visible then
						T.Gui.Size = UDim2.new(0, 16, 1, -39)
						U.Gui.Size = UDim2.new(1, -16, 0, 16)
						z.Window.GuiElems.Content.ScrollCorner.Visible = true
					else
						T.Gui.Size = UDim2.new(0, 16, 1, -23)
						U.Gui.Size = UDim2.new(1, 0, 0, 16)
						z.Window.GuiElems.Content.ScrollCorner.Visible = false
					end

					z.Index = T.Index
				end
			end

			z.NodeSorter = function(ai, aj)
				if ai.Del or aj.Del then
					return false
				end

				local ak = ai.Class
				local al = aj.Class
				if not ak then
					ak = ai.Obj.ClassName
					ai.Class = ak
				end
				if not al then
					al = aj.Obj.ClassName
					aj.Class = al
				end

				local am = C[ak]
				local an = C[al]
				if not am then
					am = t.Classes[ak] and tonumber(t.Classes[ak].ExplorerOrder) or 9999
					C[ak] = am
				end
				if not an then
					an = t.Classes[al] and tonumber(t.Classes[al].ExplorerOrder) or 9999
					C[al] = an
				end

				if am ~= an then
					return am < an
				else
					local ao, ap = tostring(ai.Obj), tostring(aj.Obj)
					if ao ~= ap then
						return ao < ap
					elseif ak ~= al then
						return ak < al
					else
						local aq = ai.Id
						if not aq then
							aq = S
							S = (S + 0.001) % 999999999
							ai.Id = aq
						end
						local ar = aj.Id
						if not ar then
							ar = S
							S = (S + 0.001) % 999999999
							aj.Id = ar
						end
						return aq < ar
					end
				end
			end

			z.Update = function()
				aa.clear(A)
				local ai, aj, ak = 0, 1, 1
				local al = {}
				local am = Enum.Font.SourceSans
				local an = Vector2.new(ab.huge, 20)
				local ao = n.Explorer.UseNameWidth
				local ap = aa.sort
				local aq = z.NodeSorter
				local ar = (F == z.SearchExpanded)
				local as = v.TextService

				local function recur(at, au)
					if au > aj then
						aj = au
					end
					au = au + 1
					if Z and not at.Sorted then
						ap(at, aq)
						at.Sorted = true
					end
					for av = 1, #at do
						local aw = at[av]

						if (ar and not D[aw]) or aw.Del then
							continue
						end

						if ao then
							local ax = aw.NameWidth
							if not ax then
								local ay = tostring(aw.Obj)
								ax = al[ay]
								if not ax then
									ax = O(as, ay, 14, am, an).X
									al[ay] = ax
								end
								aw.NameWidth = ax
							end
							if ax > ai then
								ai = ax
							end
						end

						A[ak] = aw
						ak = ak + 1
						if F[aw] and #aw > 0 then
							recur(aw, au)
						end
					end
				end

				recur(g[game], 1)

				if u.getnilinstances then
					if not (ar and not D[R]) then
						A[ak] = R
						ak = ak + 1
						if F[R] then
							recur(R, 2)
						end
					end
				end

				z.MaxNameWidth = ai
				z.MaxDepth = aj
				z.ViewWidth = ao and z.EntryIndent * aj + ai + 26 or z.EntryIndent * aj + 226
				z.UpdateView()
			end

			z.StartDrag = function(ai, aj)
				if z.Dragging then
					return
				end
				z.Dragging = true

				local ak = H:Clone()
				ak:ClearAllChildren()

				for al, am in pairs(B) do
					local an = A[al + z.Index]
					if an and h.Map[an] then
						local ao = am:Clone()
						ao.Active = false
						ao.Indent.Expand.Visible = false
						ao.Parent = ak
					end
				end

				local al = Instance.new("ScreenGui")
				al.DisplayOrder = k.DisplayOrders.Menu
				ak.Parent = al
				l.ShowGui(al)

				local am = x({
					{ 1, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "DragSelect", Size = UDim2.new(1, 0, 1, 0) } },
					{ 2, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Name = "Line", Parent = { 1 }, Size = UDim2.new(1, 0, 0, 1), ZIndex = 2 } },
					{ 3, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Name = "Line", Parent = { 1 }, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), ZIndex = 2 } },
					{ 4, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Name = "Line", Parent = { 1 }, Size = UDim2.new(0, 1, 1, 0), ZIndex = 2 } },
					{ 5, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Name = "Line", Parent = { 1 }, Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0), ZIndex = 2 } },
				})
				am.Parent = H

				local an = k.Mouse or v.Players.LocalPlayer:GetMouse()
				local function move()
					local ao = an.X - ai
					local ap = an.Y - aj
					ak.Position = UDim2.new(0, ao, 0, ap)

					for aq = 1, #B do
						local ar = B[aq]
						if l.CheckMouseInGui(ar) then
							am.Position = UDim2.new(0, ar.Indent.Position.X.Offset - U.Index, 0, ar.Position.Y.Offset)
							am.Size = UDim2.new(0, ar.Size.X.Offset - ar.Indent.Position.X.Offset, 0, 20)
							am.Visible = true
							return
						end
					end
					am.Visible = false
				end
				move()

				local ao = v.UserInputService
				local ap, aq

				ap = ao.InputChanged:Connect(function(ar)
					if ar.UserInputType == Enum.UserInputType.MouseMovement then
						move()
					end
				end)

				aq = ao.InputEnded:Connect(function(ar)
					if ar.UserInputType == Enum.UserInputType.MouseButton1 then
						aq:Disconnect()
						ap:Disconnect()
						al:Destroy()
						am:Destroy()
						z.Dragging = false

						for as = 1, #B do
							if l.CheckMouseInGui(B[as]) then
								local at = A[as + z.Index]
								if at then
									if h.Map[at] then
										return
									end
									local au = at.Obj
									local av = h.List
									for aw = 1, #av do
										local ax = av[aw]
										pcall(function()
											ax.Obj.Parent = au
										end)
									end
									z.ViewNode(av[1])
								end
								break
							end
						end
					end
				end)
			end

			z.NewListEntry = function(ai)
				local aj = G:Clone()
				aj.Position = UDim2.new(0, 0, 0, 20 * (ai - 1))

				local ak = false

				aj.InputBegan:Connect(function(al)
					local am = A[ai + z.Index]
					if not am or h.Map[am] or al.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					aj.Indent.BackgroundColor3 = n.Theme.Button
					aj.Indent.BorderSizePixel = 0
					aj.Indent.BackgroundTransparency = 0
				end)

				aj.InputEnded:Connect(function(al)
					local am = A[ai + z.Index]
					if not am or h.Map[am] or al.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					aj.Indent.BackgroundTransparency = 1
				end)

				aj.MouseButton1Down:Connect(function() end)

				aj.MouseButton1Up:Connect(function() end)

				aj.InputBegan:Connect(function(al)
					if al.UserInputType == Enum.UserInputType.MouseButton1 then
						local am, an

						local ao = k.Mouse or w:GetMouse()
						local ap = ao.X
						local aq = ao.Y

						local ar = ap - H.AbsolutePosition.X
						local as = aq - H.AbsolutePosition.Y

						am = i(game:GetService("UserInputService")).InputEnded:Connect(function(at)
							if at.UserInputType == Enum.UserInputType.MouseButton1 then
								am:Disconnect()
								an:Disconnect()
							end
						end)

						an = i(game:GetService("UserInputService")).InputChanged:Connect(function(at)
							if at.UserInputType == Enum.UserInputType.MouseMovement then
								local au = ao.X - ap
								local av = ao.Y - aq
								local aw = ab.sqrt(au ^ 2 + av ^ 2)

								if aw > 5 then
									am:Disconnect()
									an:Disconnect()
									ak = false
									z.StartDrag(ar, as)
								end
							end
						end)
					end
				end)

				aj.MouseButton2Down:Connect(function() end)

				aj.Indent.Expand.InputBegan:Connect(function(al)
					local am = A[ai + z.Index]
					if not am or al.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					z.MiscIcons:DisplayByKey(aj.Indent.Expand.Icon, F[am] and "Collapse_Over" or "Expand_Over")
				end)

				aj.Indent.Expand.InputEnded:Connect(function(al)
					local am = A[ai + z.Index]
					if not am or al.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					z.MiscIcons:DisplayByKey(aj.Indent.Expand.Icon, F[am] and "Collapse" or "Expand")
				end)

				aj.Indent.Expand.MouseButton1Down:Connect(function()
					local al = A[ai + z.Index]
					if not al or #al == 0 then
						return
					end

					F[al] = not F[al]
					z.Update()
					z.Refresh()
				end)

				aj.Parent = H
				return aj
			end

			z.Refresh = function()
				local ai = ab.max(ab.ceil(H.AbsoluteSize.Y / 20), 0)
				local aj = false
				local ak = game.IsA

				for al = 1, ai do
					local am = B[al]
					if not B[al] then
						am = z.NewListEntry(al)
						B[al] = am
						z.ClickSystem:Add(am)
					end

					local an = A[al + z.Index]
					if an then
						local ao = an.Obj
						local ap = z.EntryIndent * z.NodeDepth(an)

						am.Visible = true
						am.Position = UDim2.new(0, -U.Index, 0, am.Position.Y.Offset)
						am.Size = UDim2.new(0, z.ViewWidth, 0, 20)
						am.Indent.EntryName.Text = tostring(an.Obj)
						am.Indent.Position = UDim2.new(0, ap, 0, 0)
						am.Indent.Size = UDim2.new(1, -ap, 1, 0)

						am.Indent.EntryName.TextTruncate = (n.Explorer.UseNameWidth and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd)

						if (ak(ao, "LocalScript") or ak(ao, "Script")) and ao.Disabled then
							z.MiscIcons:DisplayByKey(am.Indent.Icon, ak(ao, "LocalScript") and "LocalScript_Disabled" or "Script_Disabled")
						else
							local aq = t.Classes[ao.ClassName]
							z.ClassIcons:Display(am.Indent.Icon, aq and aq.ExplorerImageIndex or 0)
						end

						if h.Map[an] then
							am.Indent.BackgroundColor3 = n.Theme.ListSelection
							am.Indent.BorderSizePixel = 0
							am.Indent.BackgroundTransparency = 0
						else
							if l.CheckMouseInGui(am) then
								am.Indent.BackgroundColor3 = n.Theme.Button
							else
								am.Indent.BackgroundTransparency = 1
							end
						end

						if an == X then
							aj = true
							W.Position = UDim2.new(0, ap + 25 - U.Index, 0, am.Position.Y.Offset + 2)
							W.Visible = true
						end

						if #an > 0 and F[an] ~= 0 then
							if l.CheckMouseInGui(am.Indent.Expand) then
								z.MiscIcons:DisplayByKey(am.Indent.Expand.Icon, F[an] and "Collapse_Over" or "Expand_Over")
							else
								z.MiscIcons:DisplayByKey(am.Indent.Expand.Icon, F[an] and "Collapse" or "Expand")
							end
							am.Indent.Expand.Visible = true
						else
							am.Indent.Expand.Visible = false
						end
					else
						am.Visible = false
					end
				end

				if not aj then
					W.Visible = false
				end

				for al = ai + 1, #B do
					z.ClickSystem:Remove(B[al])
					B[al]:Destroy()
					B[al] = nil
				end
			end

			z.PerformUpdate = function(ai)
				P = true
				l.FastWait(not ai and 0.1)
				if not P then
					return
				end
				P = false
				if not z.Window:IsVisible() then
					return
				end
				z.Update()
				z.Refresh()
			end

			z.ForceUpdate = function(ai)
				P = false
				z.Update()
				if not ai then
					z.Refresh()
				end
			end

			z.PerformRefresh = function()
				Q = true
				l.FastWait(0.1)
				Q = false
				if P or not z.Window:IsVisible() then
					return
				end
				z.Refresh()
			end

			z.IsNodeVisible = function(ai)
				if not ai then
					return
				end

				local aj = ai.Parent
				while aj do
					if not F[aj] then
						return false
					end
					aj = aj.Parent
				end
				return true
			end

			z.NodeDepth = function(ai)
				local aj = 0

				if ai == R then
					return 1
				end

				local ak = ai.Parent
				while ak do
					if ak == R then
						aj = aj + 1
					end
					ak = ak.Parent
					aj = aj + 1
				end
				return aj
			end

			z.SetupConnections = function()
				if J then
					J:Disconnect()
				end
				if K then
					K:Disconnect()
				end
				if L then
					L:Disconnect()
				end

				if k.Elevated then
					J = game.DescendantAdded:Connect(af)
					K = game.DescendantRemoving:Connect(ag)
				else
					J = game.DescendantAdded:Connect(function(ai)
						pcall(af, ai)
					end)
					K = game.DescendantRemoving:Connect(function(ai)
						pcall(ag, ai)
					end)
				end

				if n.Explorer.UseNameWidth then
					L = game.ItemChanged:Connect(function(ai, aj)
						if aj == "Parent" and g[ai] then
							ah(ai)
						elseif aj == "Name" and g[ai] then
							g[ai].NameWidth = nil
						end
					end)
				else
					L = game.ItemChanged:Connect(function(ai, aj)
						if aj == "Parent" and g[ai] then
							ah(ai)
						end
					end)
				end
			end

			z.ViewNode = function(ai)
				if not ai then
					return
				end

				z.MakeNodeVisible(ai)
				z.ForceUpdate(true)
				local aj = T.VisibleSpace

				for ak, al in next, A do
					if al == ai then
						local am = ak - 1
						if z.Index > am then
							T.Index = am
						elseif z.Index + aj - 1 <= am then
							T.Index = am - aj + 2
						end
					end
				end

				T:Update()
				z.Index = T.Index
				z.Refresh()
			end

			z.ViewObj = function(ai)
				z.ViewNode(g[ai])
			end

			z.MakeNodeVisible = function(ai, aj)
				if not ai then
					return
				end

				local ak = false

				if aj and not F[ai] then
					F[ai] = true
					ak = true
				end

				local al = ai.Parent
				while al do
					ak = true
					F[al] = true
					al = al.Parent
				end

				if ak and not P then
					coroutine.wrap(z.PerformUpdate)(true)
				end
			end

			z.ShowRightClick = function()
				local ai = z.RightClickContext
				ai:Clear()

				local aj = h.List
				local ak = h.Map
				local al = #V == 0
				local am = {}
				local an = s.Classes

				for ao = 1, #aj do
					local ap = aj[ao]
					local aq = ap.Class
					if not aq then
						aq = ap.Obj.ClassName
						ap.Class = aq
					end
					local ar = an[aq]
					while ar and not am[ar.Name] do
						am[ar.Name] = true
						ar = ar.Superclass
					end
				end

				ai:AddRegistered("CUT")
				ai:AddRegistered("COPY")
				ai:AddRegistered("PASTE", al)
				ai:AddRegistered("DUPLICATE")
				ai:AddRegistered("DELETE")
				ai:AddRegistered("RENAME", #aj ~= 1)

				ai:AddDivider()
				ai:AddRegistered("GROUP")
				ai:AddRegistered("UNGROUP")
				ai:AddRegistered("SELECT_CHILDREN")
				ai:AddRegistered("JUMP_TO_PARENT")
				ai:AddRegistered("EXPAND_ALL")
				ai:AddRegistered("COLLAPSE_ALL")

				ai:AddDivider()
				if F == z.SearchExpanded then
					ai:AddRegistered("CLEAR_SEARCH_AND_JUMP_TO")
				end
				if u.setclipboard then
					ai:AddRegistered("COPY_PATH")
				end
				ai:AddRegistered("INSERT_OBJECT")
				ai:AddRegistered("SAVE_INST")
				ai:AddRegistered("CALL_FUNCTION")
				ai:AddRegistered("VIEW_CONNECTIONS")
				ai:AddRegistered("GET_REFERENCES")
				ai:AddRegistered("VIEW_API")

				ai:QueueDivider()

				if am.BasePart or am.Model then
					ai:AddRegistered("TELEPORT_TO")
					ai:AddRegistered("VIEW_OBJECT")
				end

				if am.TouchTransmitter then
					ai:AddRegistered("FIRE_TOUCHTRANSMITTER", firetouchinterest == nil)
				end
				if am.ClickDetector then
					ai:AddRegistered("FIRE_CLICKDETECTOR", fireclickdetector == nil)
				end
				if am.ProximityPrompt then
					ai:AddRegistered("FIRE_PROXIMITYPROMPT", fireproximityprompt == nil)
				end
				if am.Player then
					ai:AddRegistered("SELECT_CHARACTER")
				end
				if am.Players then
					ai:AddRegistered("SELECT_LOCAL_PLAYER")
				end
				if am.LuaSourceContainer then
					ai:AddRegistered("VIEW_SCRIPT")
				end

				if ak[R] then
					ai:AddRegistered("REFRESH_NIL")
					ai:AddRegistered("HIDE_NIL")
				end

				z.LastRightClickX, z.LastRightClickY = k.Mouse.X, k.Mouse.Y
				ai:Show()
			end

			z.InitRightClick = function()
				local ai = l.ContextMenu.new()

				ai:Register("CUT", {
					Name = "Cut",
					IconMap = z.MiscIcons,
					Icon = "Cut",
					DisabledIcon = "Cut_Disabled",
					Shortcut = "Ctrl+Z",
					OnClick = function()
						local aj, ak = game.Destroy, game.Clone
						local al, am = h.List, {}
						local an = 1
						for ao = 1, #al do
							local ap = al[ao].Obj
							local aq, ar = pcall(ak, ap)
							if aq and ar then
								am[an] = ar
								an = an + 1
							end
							pcall(aj, ap)
						end
						V = am
						h:Clear()
					end,
				})

				ai:Register("COPY", {
					Name = "Copy",
					IconMap = z.MiscIcons,
					Icon = "Copy",
					DisabledIcon = "Copy_Disabled",
					Shortcut = "Ctrl+C",
					OnClick = function()
						local aj = game.Clone
						local ak, al = h.List, {}
						local am = 1
						for an = 1, #ak do
							local ao = ak[an].Obj
							local ap, aq = pcall(aj, ao)
							if ap and aq then
								al[am] = aq
								am = am + 1
							end
						end
						V = al
					end,
				})

				ai:Register("PASTE", {
					Name = "Paste Into",
					IconMap = z.MiscIcons,
					Icon = "Paste",
					DisabledIcon = "Paste_Disabled",
					Shortcut = "Ctrl+Shift+V",
					OnClick = function()
						local aj = h.List
						local ak = {}
						local al = 1
						for am = 1, #aj do
							local an = aj[am]
							local ao = an.Obj
							z.MakeNodeVisible(an, true)
							for ap = 1, #V do
								local aq = V[ap]:Clone()
								if aq then
									aq.Parent = ao
									local ar = g[aq]
									if ar then
										ak[al] = ar
										al = al + 1
									end
								end
							end
						end
						h:SetTable(ak)

						if #ak > 0 then
							z.ViewNode(ak[1])
						end
					end,
				})

				ai:Register("DUPLICATE", {
					Name = "Duplicate",
					IconMap = z.MiscIcons,
					Icon = "Copy",
					DisabledIcon = "Copy_Disabled",
					Shortcut = "Ctrl+D",
					OnClick = function()
						local aj = game.Clone
						local ak = h.List
						local al = {}
						local am = 1
						for an = 1, #ak do
							local ao = ak[an]
							local ap = ao.Obj
							local aq = ao.Parent and ao.Parent.Obj
							z.MakeNodeVisible(ao)
							local ar, as = pcall(aj, ap)
							if ar and as then
								as.Parent = aq
								local at = g[as]
								if at then
									al[am] = at
									am = am + 1
								end
							end
						end

						h:SetTable(al)
						if #al > 0 then
							z.ViewNode(al[1])
						end
					end,
				})

				ai:Register("DELETE", {
					Name = "Delete",
					IconMap = z.MiscIcons,
					Icon = "Delete",
					DisabledIcon = "Delete_Disabled",
					Shortcut = "Del",
					OnClick = function()
						local aj = game.Destroy
						local ak = h.List
						for al = 1, #ak do
							pcall(aj, ak[al].Obj)
						end
						h:Clear()
					end,
				})

				ai:Register("RENAME", {
					Name = "Rename",
					IconMap = z.MiscIcons,
					Icon = "Rename",
					DisabledIcon = "Rename_Disabled",
					Shortcut = "F2",
					OnClick = function()
						local aj = h.List
						if aj[1] then
							z.SetRenamingNode(aj[1])
						end
					end,
				})

				ai:Register("GROUP", {
					Name = "Group",
					IconMap = z.MiscIcons,
					Icon = "Group",
					DisabledIcon = "Group_Disabled",
					Shortcut = "Ctrl+G",
					OnClick = function()
						local aj = h.List
						if #aj == 0 then
							return
						end

						local ak = Instance.new("Model", aj[#aj].Obj.Parent)
						for al = 1, #aj do
							pcall(function()
								aj[al].Obj.Parent = ak
							end)
						end

						if g[ak] then
							h:Set(g[ak])
							z.ViewNode(g[ak])
						end
					end,
				})

				ai:Register("UNGROUP", {
					Name = "Ungroup",
					IconMap = z.MiscIcons,
					Icon = "Ungroup",
					DisabledIcon = "Ungroup_Disabled",
					Shortcut = "Ctrl+U",
					OnClick = function()
						local aj = {}
						local ak = 1
						local al = game.IsA

						local function ungroup(am)
							local an = am.Parent.Obj
							local ao = {}
							local ap = 1

							for aq = 1, #am do
								local ar = am[aq]
								aj[ak] = ar
								ao[ap] = ar
								ak = ak + 1
								ap = ap + 1
							end

							for aq = 1, #ao do
								pcall(function()
									ao[aq].Obj.Parent = an
								end)
							end

							am.Obj:Destroy()
						end

						for am, an in next, h.List do
							if al(an.Obj, "Model") then
								ungroup(an)
							end
						end

						h:SetTable(aj)
						if #aj > 0 then
							z.ViewNode(aj[1])
						end
					end,
				})

				ai:Register("SELECT_CHILDREN", {
					Name = "Select Children",
					IconMap = z.MiscIcons,
					Icon = "SelectChildren",
					DisabledIcon = "SelectChildren_Disabled",
					OnClick = function()
						local aj = {}
						local ak = 1
						local al = h.List

						for am = 1, #al do
							local an = al[am]
							for ao = 1, #an do
								local ap = an[ao]
								if ao == 1 then
									z.MakeNodeVisible(ap)
								end

								aj[ak] = ap
								ak = ak + 1
							end
						end

						h:SetTable(aj)
						if #aj > 0 then
							z.ViewNode(aj[1])
						else
							z.Refresh()
						end
					end,
				})

				ai:Register("JUMP_TO_PARENT", {
					Name = "Jump to Parent",
					IconMap = z.MiscIcons,
					Icon = "JumpToParent",
					OnClick = function()
						local aj = {}
						local ak = 1
						local al = h.List

						for am = 1, #al do
							local an = al[am]
							if an.Parent then
								aj[ak] = an.Parent
								ak = ak + 1
							end
						end

						h:SetTable(aj)
						if #aj > 0 then
							z.ViewNode(aj[1])
						else
							z.Refresh()
						end
					end,
				})

				ai:Register("TELEPORT_TO", {
					Name = "Teleport To",
					IconMap = z.MiscIcons,
					Icon = "TeleportTo",
					OnClick = function()
						local aj = h.List
						local ak = game.IsA

						local al = w.Character and w.Character:FindFirstChild("HumanoidRootPart")
						if not al then
							return
						end

						for am = 1, #aj do
							local an = aj[am]

							if ak(an.Obj, "BasePart") then
								al.CFrame = an.Obj.CFrame + n.Explorer.TeleportToOffset
								break
							elseif ak(an.Obj, "Model") then
								if an.Obj.PrimaryPart then
									al.CFrame = an.Obj.PrimaryPart.CFrame + n.Explorer.TeleportToOffset
									break
								else
									local ao = an.Obj:FindFirstChildWhichIsA("BasePart", true)
									if ao and g[ao] then
										al.CFrame = g[ao].Obj.CFrame + n.Explorer.TeleportToOffset
									end
								end
							end
						end
					end,
				})

				ai:Register("EXPAND_ALL", {
					Name = "Expand All",
					OnClick = function()
						local aj = h.List

						local function expand(ak)
							F[ak] = true
							for al = 1, #ak do
								if #ak[al] > 0 then
									expand(ak[al])
								end
							end
						end

						for ak = 1, #aj do
							expand(aj[ak])
						end

						z.ForceUpdate()
					end,
				})

				ai:Register("COLLAPSE_ALL", {
					Name = "Collapse All",
					OnClick = function()
						local aj = h.List

						local function expand(ak)
							F[ak] = nil
							for al = 1, #ak do
								if #ak[al] > 0 then
									expand(ak[al])
								end
							end
						end

						for ak = 1, #aj do
							expand(aj[ak])
						end

						z.ForceUpdate()
					end,
				})

				ai:Register("CLEAR_SEARCH_AND_JUMP_TO", {
					Name = "Clear Search and Jump to",
					OnClick = function()
						local aj = {}
						local ak = 1
						local al = h.List

						for am = 1, #al do
							aj[ak] = al[am]
							ak = ak + 1
						end

						h:SetTable(aj)
						z.ClearSearch()
						if #aj > 0 then
							z.ViewNode(aj[1])
						end
					end,
				})

				local aj = function(aj)
					if aj:sub(1, 28) == 'game:GetService("Workspace")' then
						aj = aj:gsub('game:GetService%("Workspace"%)', "workspace", 1)
					end
					if aj:sub(1, 27 + #w.Name) == 'game:GetService("Players").' .. w.Name then
						aj = aj:gsub('game:GetService%("Players"%).' .. w.Name, 'game:GetService("Players").LocalPlayer', 1)
					end
					return aj
				end

				ai:Register("COPY_PATH", {
					Name = "Copy Path",
					OnClick = function()
						local ak = h.List
						if #ak == 1 then
							u.setclipboard(aj(z.GetInstancePath(ak[1].Obj)))
						elseif #ak > 1 then
							local al = { "{" }
							local am = 2
							for an = 1, #ak do
								local ao = "\t" .. aj(z.GetInstancePath(ak[an].Obj)) .. ","
								if #ao > 0 then
									al[am] = ao
									am = am + 1
								end
							end
							al[am] = "}"
							u.setclipboard(aa.concat(al, "\n"))
						end
					end,
				})

				ai:Register("INSERT_OBJECT", {
					Name = "Insert Object",
					IconMap = z.MiscIcons,
					Icon = "InsertObject",
					OnClick = function()
						local ak = k.Mouse
						local al, am = z.LastRightClickX or ak.X, z.LastRightClickY or ak.Y
						z.InsertObjectContext:Show(al, am)
					end,
				})

				ai:Register("CALL_FUNCTION", { Name = "Call Function", IconMap = z.ClassIcons, Icon = 66, OnClick = function() end })

				ai:Register("GET_REFERENCES", { Name = "Get Lua References", IconMap = z.ClassIcons, Icon = 34, OnClick = function() end })

				ai:Register("SAVE_INST", { Name = "Save to File", IconMap = z.MiscIcons, Icon = "Save", OnClick = function() end })

				ai:Register("VIEW_CONNECTIONS", { Name = "View Connections", OnClick = function() end })

				ai:Register("VIEW_API", { Name = "View API Page", IconMap = z.MiscIcons, Icon = "Reference", OnClick = function() end })

				ai:Register("VIEW_OBJECT", {
					Name = "View Object (Right click to reset)",
					IconMap = z.ClassIcons,
					Icon = 5,
					OnClick = function()
						local ak = h.List
						local al = game.IsA

						for am = 1, #ak do
							local an = ak[am]

							if al(an.Obj, "BasePart") or al(an.Obj, "Model") then
								workspace.CurrentCamera.CameraSubject = an.Obj
								break
							end
						end
					end,
					OnRightClick = function()
						workspace.CurrentCamera.CameraSubject = w.Character
					end,
				})

				ai:Register("FIRE_TOUCHTRANSMITTER", {
					Name = "Fire TouchTransmitter",
					IconMap = z.ClassIcons,
					Icon = 37,
					OnClick = function()
						local ak = w.Character and w.Character:FindFirstChild("HumanoidRootPart")
						if not ak then
							return
						end
						for al, am in ipairs(h.List) do
							if am.Obj and am.Obj:IsA("TouchTransmitter") then
								firetouchinterest(ak, am.Obj.Parent, 0)
							end
						end
					end,
				})

				ai:Register("FIRE_CLICKDETECTOR", {
					Name = "Fire ClickDetector",
					IconMap = z.ClassIcons,
					Icon = 41,
					OnClick = function()
						local ak = w.Character and w.Character:FindFirstChild("HumanoidRootPart")
						if not ak then
							return
						end
						for al, am in ipairs(h.List) do
							if am.Obj and am.Obj:IsA("ClickDetector") then
								fireclickdetector(am.Obj)
							end
						end
					end,
				})

				ai:Register("FIRE_PROXIMITYPROMPT", {
					Name = "Fire ProximityPrompt",
					IconMap = z.ClassIcons,
					Icon = 124,
					OnClick = function()
						local ak = w.Character and w.Character:FindFirstChild("HumanoidRootPart")
						if not ak then
							return
						end
						for al, am in ipairs(h.List) do
							if am.Obj and am.Obj:IsA("ProximityPrompt") then
								fireproximityprompt(am.Obj)
							end
						end
					end,
				})

				ai:Register("VIEW_SCRIPT", {
					Name = "View Script",
					IconMap = z.MiscIcons,
					Icon = "ViewScript",
					OnClick = function()
						local ak = h.List[1] and h.List[1].Obj
						if ak then
							q.ViewScript(ak)
						end
					end,
				})

				ai:Register("SELECT_CHARACTER", {
					Name = "Select Character",
					IconMap = z.ClassIcons,
					Icon = 9,
					OnClick = function()
						local ak = {}
						local al = 1
						local am = h.List
						local an = game.IsA

						for ao = 1, #am do
							local ap = am[ao]
							if an(ap.Obj, "Player") and g[ap.Obj.Character] then
								ak[al] = g[ap.Obj.Character]
								al = al + 1
							end
						end

						h:SetTable(ak)
						if #ak > 0 then
							z.ViewNode(ak[1])
						else
							z.Refresh()
						end
					end,
				})

				ai:Register("SELECT_LOCAL_PLAYER", {
					Name = "Select Local Player",
					IconMap = z.ClassIcons,
					Icon = 9,
					OnClick = function()
						pcall(function()
							if g[w] then
								h:Set(g[w])
								z.ViewNode(g[w])
							end
						end)
					end,
				})

				ai:Register("REFRESH_NIL", {
					Name = "Refresh Nil Instances",
					OnClick = function()
						z.RefreshNilInstances()
					end,
				})

				ai:Register("HIDE_NIL", {
					Name = "Hide Nil Instances",
					OnClick = function()
						z.HideNilInstances()
					end,
				})

				z.RightClickContext = ai
			end

			z.HideNilInstances = function()
				aa.clear(ac)

				local ai = Instance.new("Folder").ChildAdded:Connect(function() end).Disconnect
				for aj, ak in next, ad do
					ai(ak[1])
					ai(ak[2])
				end
				aa.clear(ad)

				for aj = 1, #R do
					coroutine.wrap(ag)(R[aj].Obj)
				end

				z.Update()
				z.Refresh()
			end

			z.RefreshNilInstances = function()
				if not u.getnilinstances then
					return
				end

				local ai = u.getnilinstances()
				local aj = game
				local ak = aj.GetDescendants

				for al = 1, #ai do
					local am = ai[al]
					if am ~= aj then
						ac[am] = true

						local an = ak(am)
						for ao = 1, #an do
							ac[an[ao]] = true
						end
					end
				end

				for al = 1, #ai do
					local am = ai[al]
					local an = g[am]
					if not an then
						coroutine.wrap(af)(am)
					end
				end

				z.Update()
				z.Refresh()
			end

			z.GetInstancePath = function(ai)
				local aj = game.FindFirstChild
				local ak = game.GetChildren
				local al = ""
				local am = ai
				local an = tostring
				local ao = string.match
				local ap = string.gsub
				local aq = aa.find
				local ar = n.Explorer.CopyPathUseGetChildren
				local as = l.FormatLuaString

				while am do
					if am == game then
						al = "game" .. al
						break
					end

					local at = am.ClassName
					local au = an(am)
					local av
					if ao(au, "^[%a_][%w_]*$") then
						av = "." .. au
					else
						local aw = as(au)
						av = '["' .. aw .. '"]'
					end

					local aw = am.Parent
					if aw then
						local ax = aj(aw, au)
						if ar and ax and ax ~= am then
							local ay = ak(aw)
							local az = aq(ay, am)
							av = ":GetChildren()[" .. az .. "]"
						elseif aw == game and s.Classes[at] and s.Classes[at].Tags.Service then
							av = ':GetService("' .. at .. '")'
						end
					elseif aw == nil then
						local ax = "local getNil = function(name, class) for _, v in next, getnilinstances() do if v.ClassName == class and v.Name == name then return v end end end"
						local ay = '\n\ngetNil("%s", "%s")'
						av = ax .. ay:format(am.Name, at)
					end

					al = av .. al
					am = aw
				end

				return al
			end

			z.InitInsertObject = function()
				local ai = l.ContextMenu.new()
				ai.SearchEnabled = true
				ai.MaxHeight = 400
				ai:ApplyTheme({
					ContentColor = n.Theme.Main2,
					OutlineColor = n.Theme.Outline1,
					DividerColor = n.Theme.Outline1,
					TextColor = n.Theme.Text,
					HighlightColor = n.Theme.ButtonHover,
				})

				local aj = {}
				for ak, al in next, s.Classes do
					local am = al.Tags
					if not am.NotCreatable and not am.Service then
						local an = t.Classes[al.Name]
						aj[#aj + 1] = { al, an and an.ClassCategory or "Uncategorized" }
					end
				end
				aa.sort(aj, function(ak, al)
					if ak[2] ~= al[2] then
						return ak[2] < al[2]
					else
						return ak[1].Name < al[1].Name
					end
				end)

				local function onClick(ak)
					local al = h.List
					local am = Instance.new
					for an = 1, #al do
						local ao = al[an]
						local ap = ao.Obj
						z.MakeNodeVisible(ao, true)
						pcall(am, ak, ap)
					end
				end

				local ak = ""
				for al = 1, #aj do
					local am = aj[al][1]
					local an = t.Classes[am.Name]
					local ao = an and tonumber(an.ExplorerImageIndex) or 0
					local ap = aj[al][2]

					if ak ~= ap then
						ai:AddDivider(ap)
						ak = ap
					end
					ai:Add({ Name = am.Name, IconMap = z.ClassIcons, Icon = ao, OnClick = onClick })
				end

				z.InsertObjectContext = ai
			end

			z.SearchFilters = {
				Comparison = {
					isa = function(ai)
						local aj = string.lower
						local ak = string.find
						local al = string.split(ai)[1]
						if not al then
							return
						end
						al = aj(al)

						local am
						for an, ao in pairs(s.Classes) do
							local ap = aj(an)
							if ap == al then
								am = an
								break
							elseif ak(ap, al, 1, true) then
								am = an
							end
						end
						if not am then
							return
						end

						return {
							Headers = { "local isa = game.IsA" },
							Predicate = "isa(obj,'" .. am .. "')",
						}
					end,
					remotes = function(ai)
						return {
							Headers = { "local isa = game.IsA" },
							Predicate = "isa(obj,'RemoteEvent') or isa(obj,'RemoteFunction')",
						}
					end,
					bindables = function(ai)
						return {
							Headers = { "local isa = game.IsA" },
							Predicate = "isa(obj,'BindableEvent') or isa(obj,'BindableFunction')",
						}
					end,
					rad = function(ai)
						local aj = tonumber(ai)
						if not aj then
							return
						end

						if not v.Players.LocalPlayer.Character or not v.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not v.Players.LocalPlayer.Character.HumanoidRootPart:IsA("BasePart") then
							return
						end

						return {
							Headers = { "local isa = game.IsA", "local hrp = service.Players.LocalPlayer.Character.HumanoidRootPart" },
							Setups = { "local hrpPos = hrp.Position" },
							ObjectDefs = { "local isBasePart = isa(obj,'BasePart')" },
							Predicate = "(isBasePart and (obj.Position-hrpPos).Magnitude <= " .. aj .. ")",
						}
					end,
				},
				Specific = {
					players = function()
						return function()
							return v.Players:GetPlayers()
						end
					end,
					loadedmodules = function()
						return u.getloadedmodules
					end,
				},
				Default = function(ai, aj)
					local ak = ai:gsub('"', '\\"'):gsub("\n", "\\n")
					if aj then
						return {
							Headers = { "local find = string.find" },
							ObjectDefs = { "local objName = tostring(obj)" },
							Predicate = 'find(objName,"' .. ak .. '",1,true)',
						}
					else
						return {
							Headers = { "local lower = string.lower", "local find = string.find", "local tostring = tostring" },
							ObjectDefs = { "local lowerName = lower(tostring(obj))" },
							Predicate = 'find(lowerName,"' .. ak:lower() .. '",1,true)',
						}
					end
				end,
				SpecificDefault = function(ai)
					return {
						Headers = {},
						ObjectDefs = { "local isSpec" .. ai .. " = specResults[" .. ai .. "][node]" },
						Predicate = "isSpec" .. ai,
					}
				end,
			}

			z.BuildSearchFunc = function(ai)
				local aj, ak = {}, {}
				local al = ""
				local am = string.rep
				local an = ai:gsub("\\.", "  "):gsub('".-"', function(an)
					return am(" ", #an)
				end)
				local ao = {}
				local ap = {}
				local aq = {}
				local ar = string.find
				local as = string.sub
				local at = string.lower
				local au = string.match
				local av = {
					["("] = "(",
					[")"] = ")",
					["||"] = " or ",
					["&&"] = " and ",
				}

				local aw = z.SearchFilters.Comparison
				local ax = z.SearchFilters.Specific
				local ay = 1
				local az

				local function processFilter(aA)
					if aA.Headers then
						local aB = aA.Headers
						for aC = 1, #aB do
							ao[aB[aC]] = true
						end
					end

					if aA.ObjectDefs then
						local aB = aA.ObjectDefs
						for aC = 1, #aB do
							ap[aB[aC]] = true
						end
					end

					if aA.Setups then
						local aB = aA.Setups
						for aC = 1, #aB do
							aq[aB[aC]] = true
						end
					end

					al = al .. aA.Predicate
				end

				local aA = {}
				local aB = {}
				local aC = string.find
				local aD = string.sub

				local function findAll(aE, aF)
					local aG = #aA + 1
					local aH = 1
					local aI = #aF
					local aJ, aK, aL = aC(aE, aF, aH, true)
					while aJ do
						aA[aG] = aJ
						aB[aJ] = { aI, aF }

						aG = aG + 1
						aH = aK + 1
						aJ, aK, aL = aC(aE, aF, aH, true)
					end
				end
				tick()
				findAll(an, "&&")
				findAll(an, "||")
				findAll(an, "(")
				findAll(an, ")")
				aa.sort(aA)
				aa.insert(aA, #an + 1)

				local function inQuotes(aE)
					local aF = #aE
					if aD(aE, 1, 1) == '"' and aD(aE, aF, aF) == '"' then
						return aD(aE, 2, aF - 1)
					end
				end

				for aE = 1, #aA do
					local aF = aA[aE]
					local aG = aB[aF] or { 1 }
					local aH = av[aG[2]]
					local aI = aD(ai, ay, aF - 1)
					aI = au(aI, "^%s*(.-)%s*$") or ""

					if #aI > 0 then
						if aD(aI, 1, 1) == "!" then
							aI = aD(aI, 2)
							al = al .. "not "
						end

						local aJ = inQuotes(aI)
						if aJ then
							processFilter(z.SearchFilters.Default(aJ, true))
						else
							local aK, aL = aC(aI, "%S+")
							if aK then
								local aM = aD(aI, aK, aL)
								local aN = aD(aM, 1, 1) == "/" and at(aD(aM, 2))
								local aO = aN and aw[aN]
								local aP = aN and ax[aN]

								if aO then
									local aQ = aD(aI, aL + 2)
									local aR = aO(inQuotes(aQ) or aQ)
									if aR then
										processFilter(aR)
									else
										al = al .. "false"
									end
								elseif aP then
									local aQ = aD(aI, aL + 2)
									local aR = aP(inQuotes(aQ) or aQ)
									if aR then
										if not ak[aI] then
											aj[#aj + 1] = aR
											ak[aI] = #aj
										end
										processFilter(z.SearchFilters.SpecificDefault(ak[aI]))
									else
										al = al .. "false"
									end
								else
									processFilter(z.SearchFilters.Default(aI))
								end
							end
						end
					end

					if aH then
						al = al .. aH
						if aH == "(" and (#aI > 0 or az == ")") then
							return
						else
							az = aH
						end
					end
					ay = aF + aG[1]
				end

				local aE = ""
				local aF = ""
				local aG = ""

				for aH, aI in next, aq do
					aE = aE .. aH .. "\n"
				end
				for aH, aI in next, ao do
					aF = aF .. aH .. "\n"
				end
				for aH, aI in next, ap do
					aG = aG .. aH .. "\n"
				end

				local aH = [==[
local searchResults = searchResults
local nodes = nodes
local expandTable = Explorer.SearchExpanded
local specResults = specResults
local service = service

%s
local function search(root)	
%s
	
	local expandedpar = false
	for i = 1,#root do
		local node = root[i]
		local obj = node.Obj
		
%s
		
		if %s then
			expandTable[node] = 0
			searchResults[node] = true
			if not expandedpar then
				local parnode = node.Parent
				while parnode and (not searchResults[parnode] or expandTable[parnode] == 0) do
					expandTable[parnode] = true
					searchResults[parnode] = true
					parnode = parnode.Parent
				end
				expandedpar = true
			end
		end
		
		if #node > 0 then search(node) end
	end
end
return search]==]

				local aI = aH:format(aF, aE, aG, al)
				local aJ, aK = pcall(loadstring, aI)
				if not aJ or not aK then
					return nil, aj
				end

				local aL = setmetatable({ searchResults = D, nodes = g, Explorer = z, specResults = E, service = v }, { __index = getfenv() })
				setfenv(aK, aL)

				return aK(), aj
			end

			z.DoSearch = function(ai)
				aa.clear(z.SearchExpanded)
				aa.clear(D)
				F = (#ai == 0 and z.Expanded or z.SearchExpanded)
				Y = nil

				if #ai > 0 then
					local aj = z.SearchExpanded
					local ak

					local al = string.lower
					local am = string.find
					local an = tostring

					local ao = al(ai)

					local function defaultSearch(ap)
						local aq = false
						for as = 1, #ap do
							local at = ap[as]
							local au = at.Obj

							if am(al(an(au)), ao, 1, true) then
								aj[at] = 0
								D[at] = true
								if not aq then
									local av = at.Parent
									while av and (not D[av] or aj[av] == 0) do
										F[av] = true
										D[av] = true
										av = av.Parent
									end
									aq = true
								end
							end

							if #at > 0 then
								defaultSearch(at)
							end
						end
					end

					if k.Elevated then
						tick()
						Y, ak = z.BuildSearchFunc(ai)
					else
						Y = defaultSearch
					end

					if ak then
						aa.clear(E)
						for ap = 1, #ak do
							local aq = {}
							E[ap] = aq
							local as = ak[ap]()
							for at = 1, #as do
								local au = g[as[at]]
								if au then
									aq[au] = true
								end
							end
						end
					end

					if Y then
						tick()
						Y(g[game])
						Y(R)
					end
				end

				z.ForceUpdate()
			end

			z.ClearSearch = function()
				z.GuiElems.SearchBar.Text = ""
				F = z.Expanded
				Y = nil
			end

			z.InitSearch = function()
				local ai = z.GuiElems.ToolBar.SearchFrame.SearchBox
				z.GuiElems.SearchBar = ai

				l.ViewportTextBox.convert(ai)

				ai.FocusLost:Connect(function()
					z.DoSearch(ai.Text)
				end)
			end

			z.InitEntryTemplate = function()
				G = x({
					{ 1, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderColor3 = Color3.new(0, 0, 0), Font = 3, Name = "Entry", Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(0, 250, 0, 20), Text = "", TextSize = 14 } },
					{ 2, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.33725491166115, 0.49019610881805, 0.73725491762161), BorderSizePixel = 0, Name = "Indent", Parent = { 1 }, Position = UDim2.new(0, 20, 0, 0), Size = UDim2.new(1, -20, 1, 0) } },
					{ 3, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "EntryName", Parent = { 2 }, Position = UDim2.new(0, 26, 0, 0), Size = UDim2.new(1, -26, 1, 0), Text = "Workspace", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
					{ 4, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Font = 3, Name = "Expand", Parent = { 2 }, Position = UDim2.new(0, -20, 0, 0), Size = UDim2.new(0, 20, 0, 20), Text = "", TextSize = 14 } },
					{ 5, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://105964861876010", ImageRectOffset = Vector2.new(144, 16), ImageRectSize = Vector2.new(16, 16), Name = "Icon", Parent = { 4 }, Position = UDim2.new(0, 2, 0, 2), ScaleType = 4, Size = UDim2.new(0, 16, 0, 16) } },
					{ 6, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = j, ImageRectOffset = Vector2.new(304, 0), ImageRectSize = Vector2.new(16, 16), Name = "Icon", Parent = { 2 }, Position = UDim2.new(0, 4, 0, 2), ScaleType = 4, Size = UDim2.new(0, 16, 0, 16) } },
				})

				local ai = l.ClickSystem.new()
				ai.AllowedButtons = { 1, 2 }
				ai.OnDown:Connect(function(aj, ak, al)
					local am = aa.find(B, aj)
					if not am then
						return
					end
					local an = A[am + z.Index]
					if not an then
						return
					end
					local ao = 
B[am]

					if al == 1 then
						if ak == 2 then
							if an.Obj:IsA("LuaSourceContainer") then
								q.ViewScript(an.Obj)
							elseif #an > 0 and F[an] ~= 0 then
								F[an] = not F[an]
								z.Update()
							end
						end

						if p.SelectObject(an.Obj) then
							ai.IsRenaming = false
							return
						end

						ai.IsRenaming = h.Map[an]

						if l.IsShiftDown() then
							if not h.Piviot then
								return
							end

							local ap = aa.find(A, h.Piviot)
							local aq = aa.find(A, an)
							if not ap or not aq then
								return
							end
							ap, aq = ab.min(ap, aq), ab.max(ap, aq)

							local as = h.List
							for at = #as, 1, -1 do
								local au = as[at]
								if h.ShiftSet[au] then
									h.Map[au] = nil
									aa.remove(as, at)
								end
							end
							h.ShiftSet = {}
							for at = ap, aq do
								local au = A[at]
								if not h.Map[au] then
									h.ShiftSet[au] = true
									h.Map[au] = true
									as[#as + 1] = au
								end
							end
							h.Changed:Fire()
						elseif l.IsCtrlDown() then
							h.ShiftSet = {}
							if h.Map[an] then
								h:Remove(an)
							else
								h:Add(an)
							end
							h.Piviot = an
							ai.IsRenaming = false
						elseif not h.Map[an] then
							h.ShiftSet = {}
							h:Set(an)
							h.Piviot = an
						end
					elseif al == 2 then
						if p.SelectObject(an.Obj) then
							return
						end

						if not l.IsCtrlDown() and not h.Map[an] then
							h.ShiftSet = {}
							h:Set(an)
							h.Piviot = an
							z.Refresh()
						end
					end

					z.Refresh()
				end)

				ai.OnRelease:Connect(function(aj, ak, al)
					local am = aa.find(B, aj)
					if not am then
						return
					end
					local an = A[am + z.Index]
					if not an then
						return
					end

					if al == 1 then
						if h.Map[an] and not l.IsShiftDown() and not l.IsCtrlDown() then
							h.ShiftSet = {}
							h:Set(an)
							h.Piviot = an
							z.Refresh()
						end

						local ao = ai.ClickId
						l.FastWait(ai.ComboTime)
						if ak == 1 and ao == ai.ClickId and ai.IsRenaming and h.Map[an] then
							z.SetRenamingNode(an)
						end
					elseif al == 2 then
						z.ShowRightClick()
					end
				end)
				z.ClickSystem = ai
			end

			z.InitDelCleaner = function()
				coroutine.wrap(function()
					local ai = l.FastWait
					while true do
						local aj = false
						local ak = 0
						for al, am in next, g do
							if am.HasDel then
								local an
								for ao = 1, #am do
									if am[ao].Del then
										an = ao
										break
									end
								end
								if an then
									for ao = an + 1, #am do
										local ap = am[ao]
										if not ap.Del then
											am[an] = ap
											an = an + 1
										end
									end
									for ao = an, #am do
										am[ao] = nil
									end
								end
								am.HasDel = false
								aj = true
								ai()
							end
							ak = ak + 1
							if ak > 10000 then
								ak = 0
								ai()
							end
						end
						if aj and not Q then
							z.PerformRefresh()
						end
						ai(0.5)
					end
				end)()
			end

			z.UpdateSelectionVisuals = function()
				local ai = z.SelectionVisualsHolder
				local aj = game.IsA
				local ak = game.Clone
				if not ai then
					ai = Instance.new("ScreenGui")
					ai.Name = "ExplorerSelections"
					ai.DisplayOrder = k.DisplayOrders.Core
					l.ShowGui(ai)
					z.SelectionVisualsHolder = ai
					z.SelectionVisualCons = {}

					local al = x({
						{ 1, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Size = UDim2.new(0, 100, 0, 100) } },
						{ 2, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(0, -1, 0, -1), Size = UDim2.new(1, 2, 0, 1) } },
						{ 3, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(0, -1, 1, 0), Size = UDim2.new(1, 2, 0, 1) } },
						{ 4, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(0, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0) } },
						{ 5, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0) } },
					})
					z.SelectionVisualGui = al

					local am = Instance.new("SelectionBox")
					am.LineThickness = 0.03
					am.Color3 = Color3.fromRGB(0, 170, 255)
					z.SelectionVisualBox = am
				end
				ai:ClearAllChildren()

				for al, am in pairs(z.SelectionVisualGui:GetChildren()) do
					am.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
				end

				local al = z.SelectionVisualCons
				for am = 1, #al do
					al[am].Destroy()
				end
				aa.clear(al)

				local am = n.Explorer.PartSelectionBox
				local an = n.Explorer.GuiSelectionBox
				if not am and not an then
					return
				end

				local ao = z.SelectionVisualGui
				local ap = z.SelectionVisualBox
				local aq = l.AttachTo
				local as = h.List
				local at = 1
				local au = 0
				local av = g[workspace]
				for aw = 1, #as do
					if au > 1000 then
						break
					end
					local ax = as[aw]
					local ay = ax.Obj

					if ax ~= av then
						if aj(ay, "GuiObject") and an then
							local az = ak(ao)
							al[at] = aq(az, { Target = ay, Resize = true })
							at = at + 1
							az.Parent = ai
							au = au + 1
						elseif aj(ay, "PVInstance") and am then
							local az = ak(ap)
							az.Adornee = ay
							az.Parent = ai
							au = au + 1
						end
					end
				end
			end

			z.Init = function()
				z.ClassIcons = l.IconMap.newLinear(j, 16, 16)
				z.MiscIcons = k.MiscIcons

				V = {}

				h = l.Set.new()
				h.ShiftSet = {}
				h.Changed:Connect(p.ShowExplorerProps)
				z.Selection = h

				z.InitRightClick()
				z.InitInsertObject()
				z.SetSortingEnabled(n.Explorer.Sorting)
				z.Expanded = setmetatable({}, { __mode = "k" })
				z.SearchExpanded = setmetatable({}, { __mode = "k" })
				F = z.Expanded

				R.Obj.Name = "Nil Instances"
				R.Locked = true

				local ai = x({
					{ 1, "Folder", { Name = "ExplorerItems" } },
					{ 2, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "ToolBar", Parent = { 1 }, Size = UDim2.new(1, 0, 0, 22) } },
					{ 3, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.1176470592618, 0.1176470592618, 0.1176470592618), BorderSizePixel = 0, Name = "SearchFrame", Parent = { 2 }, Position = UDim2.new(0, 3, 0, 1), Size = UDim2.new(1, -6, 0, 18) } },
					{ 4, "TextBox", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ClearTextOnFocus = false, Font = 3, Name = "SearchBox", Parent = { 3 }, PlaceholderColor3 = Color3.new(0.39215689897537, 0.39215689897537, 0.39215689897537), PlaceholderText = "Search workspace", Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -24, 0, 18), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 0 } },
					{ 5, "UICorner", { CornerRadius = UDim.new(0, 2), Parent = { 3 } } },
					{ 6, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Reset", Parent = { 3 }, Position = UDim2.new(1, -17, 0, 1), Size = UDim2.new(0, 16, 0, 16), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
					{ 7, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://81560269887102", ImageColor3 = Color3.new(0.39215686917305, 0.39215686917305, 0.39215686917305), Parent = { 6 }, Size = UDim2.new(0, 16, 0, 16) } },
					{ 8, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Refresh", Parent = { 2 }, Position = UDim2.new(1, -20, 0, 1), Size = UDim2.new(0, 18, 0, 18), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, Visible = false } },
					{ 9, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://134503731840902", Parent = { 8 }, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(0, 12, 0, 12) } },
					{ 10, "Frame", { BackgroundColor3 = Color3.new(0.15686275064945, 0.15686275064945, 0.15686275064945), BorderSizePixel = 0, Name = "ScrollCorner", Parent = { 1 }, Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, 16, 0, 16), Visible = false } },
					{ 11, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Name = "List", Parent = { 1 }, Position = UDim2.new(0, 0, 0, 23), Size = UDim2.new(1, 0, 1, -23) } },
				})

				I = ai.ToolBar
				H = ai.List

				z.GuiElems.ToolBar = I
				z.GuiElems.TreeFrame = H

				T = l.ScrollBar.new()
				T.WheelIncrement = 3
				T.Gui.Position = UDim2.new(1, -16, 0, 23)
				T:SetScrollFrame(H)
				T.Scrolled:Connect(function()
					z.Index = T.Index
					z.Refresh()
				end)

				U = l.ScrollBar.new(true)
				U.Increment = 5
				U.WheelIncrement = z.EntryIndent
				U.Gui.Position = UDim2.new(0, 0, 1, -16)
				U.Scrolled:Connect(function()
					z.Refresh()
				end)

				local aj = l.Window.new()
				z.Window = aj
				aj:SetTitle("Explorer")
				aj.GuiElems.Line.Position = UDim2.new(0, 0, 0, 22)

				z.InitEntryTemplate()
				I.Parent = aj.GuiElems.Content
				H.Parent = aj.GuiElems.Content
				ai.ScrollCorner.Parent = aj.GuiElems.Content
				T.Gui.Parent = aj.GuiElems.Content
				U.Gui.Parent = aj.GuiElems.Content

				z.InitRenameBox()
				z.InitSearch()
				z.InitDelCleaner()
				h.Changed:Connect(z.UpdateSelectionVisuals)

				aj.GuiElems.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if z.Active then
						z.UpdateView()
						z.Refresh()
					end
				end)
				aj.OnActivate:Connect(function()
					z.Active = true
					z.UpdateView()
					z.Update()
					z.Refresh()
				end)
				aj.OnRestore:Connect(function()
					z.Active = true
					z.UpdateView()
					z.Update()
					z.Refresh()
				end)
				aj.OnDeactivate:Connect(function()
					z.Active = false
				end)
				aj.OnMinimize:Connect(function()
					z.Active = false
				end)

				_ = n.Explorer.AutoUpdateSearch

				g[game] = { Obj = game }
				F[g[game]] = true

				if u.getnilinstances then
					g[R.Obj] = R
				end

				z.SetupConnections()

				local ak = N(game)
				if k.Elevated then
					for al = 1, #ak do
						local am = ak[al]
						local an = g[M(am, "Instance")]
						if not an then
							continue
						end
						local ao = {
							Obj = am,
							Parent = an,
						}
						g[am] = ao
						an[#an + 1] = ao
					end
				else
					for al = 1, #ak do
						local am = ak[al]
						local an, ao = pcall(M, am, "Instance")
						local ap = g[ao]
						if not ap then
							continue
						end
						local aq = {
							Obj = am,
							Parent = ap,
						}
						g[am] = aq
						ap[#ap + 1] = aq
					end
				end
			end

			return z
		end

		return { InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main }
	end,
	Properties = function()
		local aa, ab, ac, ad
		local ae, af, ag, ah
		local ai, aj, ak, al, am, an, ao

		local function initDeps(ap)
			aa = ap.Main
			ab = ap.Lib
			ac = ap.Apps
			ad = ap.Settings

			ai = ap.API
			aj = ap.RMD
			ak = ap.env
			al = ap.service
			am = ap.plr
			an = ap.create
			ao = ap.createSimple
		end

		local function initAfterMain()
			ae = ac.Explorer
			af = ac.Properties
			ag = ac.ScriptViewer
			ah = ac.Notebook
		end

		local function main()
			local ap = {}

			local aq, as, at
			local au, av
			local aw
			local ax, ay, az, aA, aB, aC = {}, {}, {}, {}, {}, {}
			local aD, aE, aF
			local aG, aH = {}, {}
			local aI, aJ = table, string
			local aK = game.GetPropertyChangedSignal
			local aL = game.GetAttributeChangedSignal
			local aM = game.IsA
			local aN = game.GetAttribute
			local aO = game.SetAttribute

			ap.GuiElems = {}
			ap.Index = 0
			ap.ViewWidth = 0
			ap.MinInputWidth = 100
			ap.EntryIndent = 16
			ap.EntryOffset = 4
			ap.NameWidthCache = {}
			ap.SubPropCache = {}
			ap.ClassLists = {}
			ap.SearchText = ""

			ap.AddAttributeProp = { Category = "Attributes", Class = "", Name = "", SpecialRow = "AddAttribute", Tags = {} }
			ap.SoundPreviewProp = { Category = "Data", ValueType = { Name = "SoundPlayer" }, Class = "Sound", Name = "Preview", Tags = {} }

			ap.IgnoreProps = { DataModel = { PrivateServerId = true, PrivateServerOwnerId = true, VIPServerId = true, VIPServerOwnerId = true } }

			ap.ExpandableTypes = { Vector2 = true, Vector3 = true, UDim = true, UDim2 = true, CFrame = true, Rect = true, PhysicalProperties = true, Ray = true, NumberRange = true, Faces = true, Axes = true }

			ap.ExpandableProps = {
				["Sound.SoundId"] = true,
			}

			ap.CollapsedCategories = {
				["Surface Inputs"] = true,
				Surface = true,
			}

			ap.ConflictSubProps = { Vector2 = { "X", "Y" }, Vector3 = { "X", "Y", "Z" }, UDim = { "Scale", "Offset" }, UDim2 = { "X", "X.Scale", "X.Offset", "Y", "Y.Scale", "Y.Offset" }, CFrame = { "Position", "Position.X", "Position.Y", "Position.Z", "RightVector", "RightVector.X", "RightVector.Y", "RightVector.Z", "UpVector", "UpVector.X", "UpVector.Y", "UpVector.Z", "LookVector", "LookVector.X", "LookVector.Y", "LookVector.Z" }, Rect = { "Min.X", "Min.Y", "Max.X", "Max.Y" }, PhysicalProperties = { "Density", "Elasticity", "ElasticityWeight", "Friction", "FrictionWeight" }, Ray = { "Origin", "Origin.X", "Origin.Y", "Origin.Z", "Direction", "Direction.X", "Direction.Y", "Direction.Z" }, NumberRange = { "Min", "Max" }, Faces = { "Back", "Bottom", "Front", "Left", "Right", "Top" }, Axes = { "X", "Y", "Z" } }

			ap.ConflictIgnore = { BasePart = { ResizableFaces = true } }

			ap.RoundableTypes = { float = true, double = true, Color3 = true, UDim = true, UDim2 = true, Vector2 = true, Vector3 = true, NumberRange = true, Rect = true, NumberSequence = true, ColorSequence = true, Ray = true, CFrame = true }

			ap.TypeNameConvert = { number = "double", boolean = "bool" }

			ap.ToNumberTypes = { int = true, int64 = true, float = true, double = true }

			ap.DefaultPropValue = {
				string = "",
				bool = false,
				double = 0,
				UDim = UDim.new(0, 0),
				UDim2 = UDim2.new(0, 0, 0, 0),
				BrickColor = BrickColor.new("Medium stone grey"),
				Color3 = Color3.new(1, 1, 1),
				Vector2 = Vector2.new(0, 0),
				Vector3 = Vector3.new(0, 0, 0),
				NumberSequence = NumberSequence.new(1),
				ColorSequence = ColorSequence.new(Color3.new(1, 1, 1)),
				NumberRange = NumberRange.new(0),
				Rect = Rect.new(0, 0, 0, 0),
			}

			ap.AllowedAttributeTypes = { "string", "boolean", "number", "UDim", "UDim2", "BrickColor", "Color3", "Vector2", "Vector3", "NumberSequence", "ColorSequence", "NumberRange", "Rect" }

			ap.StringToValue = function(aP, aQ)
				local aR = aP.ValueType
				local k = aR.Name

				if k == "string" or k == "Content" then
					return aQ
				elseif ap.ToNumberTypes[k] then
					return tonumber(aQ)
				elseif k == "Vector2" then
					local l = aQ:split(",")
					local m, n = tonumber(l[1]), tonumber(l[2])
					if m and n and #l >= 2 then
						return Vector2.new(m, n)
					end
				elseif k == "Vector3" then
					local l = aQ:split(",")
					local m, n, o = tonumber(l[1]), tonumber(l[2]), tonumber(l[3])
					if m and n and o and #l >= 3 then
						return Vector3.new(m, n, o)
					end
				elseif k == "UDim" then
					local l = aQ:split(",")
					local m, n = tonumber(l[1]), tonumber(l[2])
					if m and n and #l >= 2 then
						return UDim.new(m, n)
					end
				elseif k == "UDim2" then
					local l = aQ:gsub("[{}]", ""):split(",")
					local m, n, o, p = tonumber(l[1]), tonumber(l[2]), tonumber(l[3]), tonumber(l[4])
					if m and n and o and p and #l >= 4 then
						return UDim2.new(m, n, o, p)
					end
				elseif k == "CFrame" then
					local l = aQ:split(",")
					local m, n = pcall(CFrame.new, unpack(l))
					if m and #l >= 12 then
						return n
					end
				elseif k == "Rect" then
					local l = aQ:split(",")
					local m, n = pcall(Rect.new, unpack(l))
					if m and #l >= 4 then
						return n
					end
				elseif k == "Ray" then
					local l = aQ:gsub("[{}]", ""):split(",")
					local m, n = pcall(Vector3.new, unpack(l, 1, 3))
					local o, p = pcall(Vector3.new, unpack(l, 4, 6))
					if m and o and #l >= 6 then
						return Ray.new(n, p)
					end
				elseif k == "NumberRange" then
					local l = aQ:split(",")
					local m, n = pcall(NumberRange.new, unpack(l))
					if m and #l >= 1 then
						return n
					end
				elseif k == "Color3" then
					local l = aQ:gsub("[{}]", ""):split(",")
					local m, n = pcall(Color3.fromRGB, unpack(l))
					if m and #l >= 3 then
						return n
					end
				end

				return nil
			end

			ap.ValueToString = function(aP, aQ)
				local aR = aP.ValueType
				local k = aR.Name

				if k == "Color3" then
					return ab.ColorToBytes(aQ)
				elseif k == "NumberRange" then
					return aQ.Min .. ", " .. aQ.Max
				end

				return tostring(aQ)
			end

			ap.GetIndexableProps = function(aP, aQ)
				if not aa.Elevated then
					if not pcall(function()
						return aP.ClassName
					end) then
						return nil
					end
				end

				local aR = ap.IgnoreProps[aQ.Name] or {}

				local k = {}
				local l = 1
				local m = aQ.Properties
				for n = 1, #m do
					local o = m[n]
					if not aR[o.Name] then
						local p = pcall(function()
							return aP[o.Name]
						end)
						if p then
							k[l] = o
							l = l + 1
						end
					end
				end

				return k
			end

			ap.FindFirstObjWhichIsA = function(aP)
				local aQ = ap.ClassLists[aP] or {}
				if aQ and #aQ > 0 then
					return aQ[1]
				end

				return nil
			end

			ap.ComputeConflicts = function(aP)
				local aQ = ad.Properties.MaxConflictCheck
				local aR = ae.Selection.List
				local k = ap.ClassLists
				local l = aJ.split
				local m = aI.clear
				local n = ap.ConflictIgnore
				local o = {}
				local p = aP and { aP } or ax

				if aP then
					local q = aP.Class .. "." .. aP.Name
					aC[q] = nil
					local r = ap.ConflictSubProps[aP.ValueType.Name] or {}
					for s = 1, #r do
						aC[q .. "." .. r[s]] = nil
					end
				else
					aI.clear(aC)
				end

				if #aR > 0 then
					for q = 1, #p do
						local r = p[q]
						local s, t = r.Name, r.Class
						local u = r.RootType or r.ValueType
						local v = u.Name
						local w = r.AttributeName
						local x = t .. "." .. s

						local y = 0
						local z = ap.ConflictSubProps[v] or {}
						local A = #z
						local B = A + 1
						local C = 0
						local D = {}
						local E = n[t] and n[t][s]
						local F = (v == "PhysicalProperties")
						local G = r.IsAttribute
						local H = r.MultiType

						m(o)

						if not H then
							local I, J, K
							local L = k[r.Class] or {}
							for M = 1, #L do
								local N = L[M]
								if not K then
									if G then
										I = aN(N, w)
										if I ~= nil then
											J = N
											K = true
										end
									else
										I = N[s]
										J = N
										K = true
									end
									if E then
										break
									end
								else
									local O, P
									if G then
										O = aN(N, w)
										if O == nil then
											P = true
										end
									else
										O = N[s]
									end

									if not P then
										if not o[1] then
											if F then
												if (I and true or false) ~= (O and true or false) then
													o[1] = true
													C = C + 1
												end
											elseif I ~= O then
												o[1] = true
												C = C + 1
											end
										end

										if A > 0 then
											for Q = 1, A do
												local R = D[Q]
												if not R then
													R = l(z[Q], ".")
													D[Q] = R
												end

												local S = I
												local T = O

												for U = 1, #R do
													if not S or not T then
														break
													end
													local V = R[U]
													S = S[V]
													T = T[V]
												end

												local U = Q + 1
												if not o[U] and S ~= T then
													o[U] = true
													C = C + 1
												end
											end
										end

										if C == B then
											break
										end
									end
								end

								y = y + 1
								if y == aQ then
									break
								end
							end

							if not o[1] then
								aC[x] = J
							end
							for M = 1, A do
								if not o[M + 1] then
									aC[x .. "." .. z[M]] = J
								end
							end
						end
					end
				end

				if aP then
					ap.Refresh()
				end
			end

			ad.Properties.ShowAttributes = true
			ap.ShowExplorerProps = function()
				local aP = ad.Properties.MaxConflictCheck
				local aQ = ae.Selection.List
				local aR = {}
				local k = 1
				local l = aa.Elevated
				local m, n = ad.Properties.ShowDeprecated, ad.Properties.ShowHidden
				local o = ai.Classes
				local p = {}
				local q = aJ.lower
				local r = aj.PropertyOrders
				local s = game.GetAttributes
				local t = ad.Properties.MaxAttributes
				local u = ad.Properties.ShowAttributes
				local v = {}
				local w = 0
				local x = typeof
				local y = ap.TypeNameConvert

				aI.clear(ax)

				for z = 1, #aQ do
					local A = aQ[z]
					local B = A.Obj
					local C = A.Class
					if not C then
						C = B.ClassName
						A.Class = C
					end

					local D = o[C]
					while D do
						local E = D.Name
						if not aR[E] then
							local F = aA[E]
							if not F then
								F = ap.GetIndexableProps(B, D)
								aA[E] = F
							end

							for G = 1, #F do
								local H = F[G]
								local I = H.Tags
								if (not I.Deprecated or m) and (not I.Hidden or n) then
									ax[k] = H
									k = k + 1
								end
							end
							aR[E] = true
						end

						local F = p[E]
						if not F then
							F = {}
							p[E] = F
						end
						F[#F + 1] = B

						D = D.Superclass
					end

					if u and w < t then
						local E = s(B)
						for F, G in pairs(E) do
							local H = x(G)
							if not v[F] then
								local I = (H == "Instance" and "Class") or (H == "EnumItem" and "Enum") or "Other"
								local J = { Name = y[H] or H, Category = I }
								local K = { IsAttribute = true, Name = "ATTR_" .. F, AttributeName = F, DisplayName = F, Class = "Instance", ValueType = J, Category = "Attributes", Tags = {} }
								ax[k] = K
								k = k + 1
								w = w + 1
								v[F] = { H, K }
								if w == t then
									break
								end
							elseif v[F][1] ~= H then
								v[F][2].MultiType = true
								v[F][2].Tags.ReadOnly = true
								v[F][2].ValueType = { Name = "string" }
							end
						end
					end
				end

				aI.sort(ax, function(z, A)
					if z.Category ~= A.Category then
						return (aw[z.Category] or 9999) < (aw[A.Category] or 9999)
					else
						local B = (r[z.Class] and r[z.Class][z.Name]) or 9999999
						local C = (r[A.Class] and r[A.Class][A.Name]) or 9999999
						if B ~= C then
							return B < C
						else
							return q(z.Name) < q(A.Name)
						end
					end
				end)

				ap.ClassLists = p
				ap.ComputeConflicts()

				if #ax > 0 then
					ax[#ax + 1] = ap.AddAttributeProp
				end

				ap.Update()
				ap.Refresh()
			end

			ap.UpdateView = function()
				local aQ = math.ceil(at.AbsoluteSize.Y / 23)
				local aR = at.AbsoluteSize.X
				local k = ap.ViewWidth + ap.MinInputWidth

				au.VisibleSpace = aQ
				au.TotalSpace = #ay + 1
				av.VisibleSpace = aR
				av.TotalSpace = k

				au.Gui.Visible = #ay + 1 > aQ
				av.Gui.Visible = ad.Properties.ScaleType == 0 and k > aR

				local l = at.Size
				at.Size = UDim2.new(1, (au.Gui.Visible and -16 or 0), 1, (av.Gui.Visible and -39 or -23))
				if l ~= at.Size then
					ap.UpdateView()
				else
					au:Update()
					av:Update()

					if au.Gui.Visible and av.Gui.Visible then
						au.Gui.Size = UDim2.new(0, 16, 1, -39)
						av.Gui.Size = UDim2.new(1, -16, 0, 16)
						ap.Window.GuiElems.Content.ScrollCorner.Visible = true
					else
						au.Gui.Size = UDim2.new(0, 16, 1, -23)
						av.Gui.Size = UDim2.new(1, 0, 0, 16)
						ap.Window.GuiElems.Content.ScrollCorner.Visible = false
					end

					ap.Index = au.Index
				end
			end

			ap.MakeSubProp = function(aQ, aR, k, l)
				local m = {}
				for n, o in pairs(aQ) do
					m[n] = o
				end
				m.RootType = m.RootType or m.ValueType
				m.ValueType = k
				m.SubName = m.SubName and (m.SubName .. aR) or aR
				m.DisplayName = l

				return m
			end

			ap.GetExpandedProps = function(aQ)
				local aR = {}
				local k = aQ.ValueType
				local l = k.Name
				local m = ap.MakeSubProp

				if l == "Vector2" then
					aR[1] = m(aQ, ".X", { Name = "float" })
					aR[2] = m(aQ, ".Y", { Name = "float" })
				elseif l == "Vector3" then
					aR[1] = m(aQ, ".X", { Name = "float" })
					aR[2] = m(aQ, ".Y", { Name = "float" })
					aR[3] = m(aQ, ".Z", { Name = "float" })
				elseif l == "CFrame" then
					aR[1] = m(aQ, ".Position", { Name = "Vector3" })
					aR[2] = m(aQ, ".RightVector", { Name = "Vector3" })
					aR[3] = m(aQ, ".UpVector", { Name = "Vector3" })
					aR[4] = m(aQ, ".LookVector", { Name = "Vector3" })
				elseif l == "UDim" then
					aR[1] = m(aQ, ".Scale", { Name = "float" })
					aR[2] = m(aQ, ".Offset", { Name = "int" })
				elseif l == "UDim2" then
					aR[1] = m(aQ, ".X", { Name = "UDim" })
					aR[2] = m(aQ, ".Y", { Name = "UDim" })
				elseif l == "Rect" then
					aR[1] = m(aQ, ".Min.X", { Name = "float" }, "X0")
					aR[2] = m(aQ, ".Min.Y", { Name = "float" }, "Y0")
					aR[3] = m(aQ, ".Max.X", { Name = "float" }, "X1")
					aR[4] = m(aQ, ".Max.Y", { Name = "float" }, "Y1")
				elseif l == "PhysicalProperties" then
					aR[1] = m(aQ, ".Density", { Name = "float" })
					aR[2] = m(aQ, ".Elasticity", { Name = "float" })
					aR[3] = m(aQ, ".ElasticityWeight", { Name = "float" })
					aR[4] = m(aQ, ".Friction", { Name = "float" })
					aR[5] = m(aQ, ".FrictionWeight", { Name = "float" })
				elseif l == "Ray" then
					aR[1] = m(aQ, ".Origin", { Name = "Vector3" })
					aR[2] = m(aQ, ".Direction", { Name = "Vector3" })
				elseif l == "NumberRange" then
					aR[1] = m(aQ, ".Min", { Name = "float" })
					aR[2] = m(aQ, ".Max", { Name = "float" })
				elseif l == "Faces" then
					aR[1] = m(aQ, ".Back", { Name = "bool" })
					aR[2] = m(aQ, ".Bottom", { Name = "bool" })
					aR[3] = m(aQ, ".Front", { Name = "bool" })
					aR[4] = m(aQ, ".Left", { Name = "bool" })
					aR[5] = m(aQ, ".Right", { Name = "bool" })
					aR[6] = m(aQ, ".Top", { Name = "bool" })
				elseif l == "Axes" then
					aR[1] = m(aQ, ".X", { Name = "bool" })
					aR[2] = m(aQ, ".Y", { Name = "bool" })
					aR[3] = m(aQ, ".Z", { Name = "bool" })
				end

				if aQ.Name == "SoundId" and aQ.Class == "Sound" then
					aR[1] = ap.SoundPreviewProp
				end

				return aR
			end

			ap.Update = function()
				aI.clear(ay)

				local aQ = ap.NameWidthCache
				local aR
				local k = 1
				local l, m = 0, 1

				local n = al.TextService
				local o = n.GetTextSize
				local p = Enum.Font.SourceSans
				local q = Vector2.new(math.huge, 20)
				local r = aJ.split
				local s = ap.EntryIndent
				local t = ad.Properties.ScaleType == 0
				local u, v = aJ.find, aJ.lower
				local w = (#ap.SearchText > 0 and v(ap.SearchText))

				local function recur(x, y)
					for z = 1, #x do
						local A = x[z]
						local B = A.Name
						local C = A.SubName
						local D = A.Category

						local E
						if w and y == 1 then
							if u(v(B), w, 1, true) then
								E = true
							end
						else
							E = true
						end

						if E and aR ~= D then
							ay[k] = { CategoryName = D }
							k = k + 1
							aR = D
						end

						if (az["CAT_" .. D] and E) or A.SpecialRow then
							if y > 1 then
								A.Depth = y
								if y > m then
									m = y
								end
							end

							if t then
								local F = C and r(C, ".")
								local G = A.DisplayName or (F and F[#F]) or B

								local H = aQ[G]
								if not H then
									H = o(n, G, 14, p, q).X
									aQ[G] = H
								end

								local I = H + s * y
								if I > l then
									l = I
								end
							end

							ay[k] = A
							k = k + 1

							local F = A.Class .. "." .. A.Name .. (A.SubName or "")
							if az[F] then
								local G = y + 1
								local H = ap.GetExpandedProps(A)
								if #H > 0 then
									recur(H, G)
								end
							end
						end
					end
				end
				recur(ax, 1)

				aF = nil
				ap.ViewWidth = l + 9 + ap.EntryOffset
				ap.UpdateView()
			end

			ap.NewPropEntry = function(aQ)
				local aR = ap.EntryTemplate:Clone()
				local k = aR.NameFrame
				local l = aR.ValueFrame
				local m = ab.Checkbox.new(1)
				m.Gui.Position = UDim2.new(0, 3, 0, 3)
				m.Gui.Parent = l
				m.OnInput:Connect(function()
					local n = ay[aQ + ap.Index]
					if not n then
						return
					end

					if n.ValueType.Name == "PhysicalProperties" then
						ap.SetProp(n, m.Toggled and true or nil)
					else
						ap.SetProp(n, m.Toggled)
					end
				end)
				aG[aQ] = m

				local n = aa.MiscIcons:GetLabel()
				n.Position = UDim2.new(0, 2, 0, 3)
				n.Parent = aR.ValueFrame.RightButton

				aR.Position = UDim2.new(0, 0, 0, 23 * (aQ - 1))

				k.Expand.InputBegan:Connect(function(o)
					local p = ay[aQ + ap.Index]
					if not p or o.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					local q = (p.CategoryName and "CAT_" .. p.CategoryName) or p.Class .. "." .. p.Name .. (p.SubName or "")

					aa.MiscIcons:DisplayByKey(aR.NameFrame.Expand.Icon, az[q] and "Collapse_Over" or "Expand_Over")
				end)

				k.Expand.InputEnded:Connect(function(o)
					local p = ay[aQ + ap.Index]
					if not p or o.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					local q = (p.CategoryName and "CAT_" .. p.CategoryName) or p.Class .. "." .. p.Name .. (p.SubName or "")

					aa.MiscIcons:DisplayByKey(aR.NameFrame.Expand.Icon, az[q] and "Collapse" or "Expand")
				end)

				k.Expand.MouseButton1Down:Connect(function()
					local o = ay[aQ + ap.Index]
					if not o then
						return
					end

					local p = (o.CategoryName and "CAT_" .. o.CategoryName) or o.Class .. "." .. o.Name .. (o.SubName or "")
					if not o.CategoryName and not ap.ExpandableTypes[o.ValueType and o.ValueType.Name] and not ap.ExpandableProps[p] then
						return
					end

					az[p] = not az[p]
					ap.Update()
					ap.Refresh()
				end)

				k.PropName.InputBegan:Connect(function(o)
					local p = ay[aQ + ap.Index]
					if not p then
						return
					end
					if o.UserInputType == Enum.UserInputType.MouseMovement and not k.PropName.TextFits then
						local q = ap.FullNameFrame
						local r = aJ.split(p.Class .. "." .. p.Name .. (p.SubName or ""), ".")
						local s = p.DisplayName or r[#r]
						local t = al.TextService:GetTextSize(s, 14, Enum.Font.SourceSans, Vector2.new(math.huge, 20)).X

						q.TextLabel.Text = s

						q.Size = UDim2.new(0, t + 4, 0, 22)
						q.Visible = true
						ap.FullNameFrameIndex = aQ
						ap.FullNameFrameAttach.SetData(q, { Target = k })
						ap.FullNameFrameAttach.Enable()
					end
				end)

				k.PropName.InputEnded:Connect(function(o)
					if o.UserInputType == Enum.UserInputType.MouseMovement and ap.FullNameFrameIndex == aQ then
						ap.FullNameFrame.Visible = false
						ap.FullNameFrameAttach.Disable()
					end
				end)

				l.ValueBox.MouseButton1Down:Connect(function()
					local o = ay[aQ + ap.Index]
					if not o then
						return
					end

					ap.SetInputProp(o, aQ)
				end)

				l.ColorButton.MouseButton1Down:Connect(function()
					local o = ay[aQ + ap.Index]
					if not o then
						return
					end

					ap.SetInputProp(o, aQ, "color")
				end)

				l.RightButton.MouseButton1Click:Connect(function()
					local o = ay[aQ + ap.Index]
					if not o then
						return
					end

					local p = o.Class .. "." .. o.Name .. (o.SubName or "")
					local q = aF and (aF.Class .. "." .. aF.Name .. (aF.SubName or ""))

					if p == q and aF.ValueType.Category == "Class" then
						aF = nil
						ap.SetProp(o, nil)
					else
						ap.SetInputProp(o, aQ, "right")
					end
				end)

				k.ToggleAttributes.MouseButton1Click:Connect(function()
					ad.Properties.ShowAttributes = not ad.Properties.ShowAttributes
					ap.ShowExplorerProps()
				end)

				aR.RowButton.MouseButton1Click:Connect(function()
					ap.DisplayAddAttributeWindow()
				end)

				aR.EditAttributeButton.MouseButton1Down:Connect(function()
					local o = ay[aQ + ap.Index]
					if not o then
						return
					end

					ap.DisplayAttributeContext(o)
				end)

				l.SoundPreview.ControlButton.MouseButton1Click:Connect(function()
					if ap.PreviewSound and ap.PreviewSound.Playing then
						ap.SetSoundPreview(false)
					else
						local o = ap.FindFirstObjWhichIsA("Sound")
						if o then
							ap.SetSoundPreview(o)
						end
					end
				end)

				l.SoundPreview.InputBegan:Connect(function(o)
					if o.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					local p, q
					p = al.UserInputService.InputEnded:Connect(function(r)
						if r.UserInputType ~= Enum.UserInputType.MouseButton1 then
							return
						end
						p:Disconnect()
						q:Disconnect()
					end)

					local r = aR.ValueFrame.SoundPreview.TimeLine
					local s = ap.FindFirstObjWhichIsA("Sound")
					if s then
						ap.SetSoundPreview(s, true)
					end

					local function update(t)
						local u = ap.PreviewSound
						if not u or u.TimeLength == 0 then
							return
						end

						local v = t.Position.X
						local w = r.AbsoluteSize
						local x = v - r.AbsolutePosition.X

						if w.X <= 1 then
							return
						end
						if x < 0 then
							x = 0
						elseif x >= w.X then
							x = w.X - 1
						end

						local y = (x / (w.X - 1))
						u.TimePosition = y * u.TimeLength
						r.Slider.Position = UDim2.new(y, -4, 0, -8)
					end
					update(o)

					q = al.UserInputService.InputChanged:Connect(function(t)
						if t.UserInputType == Enum.UserInputType.MouseMovement then
							update(t)
						end
					end)
				end)

				aR.Parent = at

				return {
					Gui = aR,
					GuiElems = {
						NameFrame = k,
						ValueFrame = l,
						PropName = k.PropName,
						ValueBox = l.ValueBox,
						Expand = k.Expand,
						ColorButton = l.ColorButton,
						ColorPreview = l.ColorButton.ColorPreview,
						Gradient = l.ColorButton.ColorPreview.UIGradient,
						EnumArrow = l.EnumArrow,
						Checkbox = l.Checkbox,
						RightButton = l.RightButton,
						RightButtonIcon = n,
						RowButton = aR.RowButton,
						EditAttributeButton = aR.EditAttributeButton,
						ToggleAttributes = k.ToggleAttributes,
						SoundPreview = l.SoundPreview,
						SoundPreviewSlider = l.SoundPreview.TimeLine.Slider,
					},
				}
			end

			ap.GetSoundPreviewEntry = function()
				for aQ = 1, #ay do
					if ay[aQ] == ap.SoundPreviewProp then
						return aB[aQ - ap.Index]
					end
				end
			end

			ap.SetSoundPreview = function(aQ, aR)
				local k = ap.PreviewSound
				if not k then
					k = Instance.new("Sound")
					k.Name = "Preview"
					k.Paused:Connect(function()
						local l = ap.GetSoundPreviewEntry()
						if l then
							aa.MiscIcons:DisplayByKey(l.GuiElems.SoundPreview.ControlButton.Icon, "Play")
						end
					end)
					k.Resumed:Connect(function()
						ap.Refresh()
					end)
					k.Ended:Connect(function()
						local l = ap.GetSoundPreviewEntry()
						if l then
							l.GuiElems.SoundPreviewSlider.Position = UDim2.new(0, -4, 0, -8)
						end
						ap.Refresh()
					end)
					k.Parent = aq.Gui
					ap.PreviewSound = k
				end

				if not aQ then
					k:Pause()
				else
					local l = k.SoundId ~= aQ.SoundId
					k.SoundId = aQ.SoundId
					k.PlaybackSpeed = aQ.PlaybackSpeed
					k.Volume = aQ.Volume
					if l then
						k.TimePosition = 0
					end
					if not aR then
						k:Resume()
					end

					coroutine.wrap(function()
						local m = tick()
						ap.SoundPreviewTime = m
						while m == ap.SoundPreviewTime and k.Playing do
							local n = ap.GetSoundPreviewEntry()
							if n then
								local o = k.TimeLength
								local p = k.TimePosition / (o == 0 and 1 or o)
								n.GuiElems.SoundPreviewSlider.Position = UDim2.new(p, -4, 0, -8)
							end
							ab.FastWait()
						end
					end)()
					ap.Refresh()
				end
			end

			ap.DisplayAttributeContext = function(aQ)
				local aR = ap.AttributeContext
				if not aR then
					aR = ab.ContextMenu.new()
					aR.Iconless = true
					aR.Width = 80
				end
				aR:Clear()

				aR:Add({
					Name = "Edit",
					OnClick = function()
						ap.DisplayAddAttributeWindow(aQ)
					end,
				})
				aR:Add({
					Name = "Delete",
					OnClick = function()
						ap.SetProp(aQ, nil, true)
						ap.ShowExplorerProps()
					end,
				})

				aR:Show()
			end

			ap.DisplayAddAttributeWindow = function(aQ)
				local aR = ap.AddAttributeWindow
				if not aR then
					aR = ab.Window.new()
					aR.Alignable = false
					aR.Resizable = false
					aR:SetTitle("Add Attribute")
					aR:SetSize(200, 130)

					local k = ab.Button.new()
					local l = ab.Label.new()
					l.Text = "Name"
					l.Position = UDim2.new(0, 30, 0, 10)
					l.Size = UDim2.new(0, 40, 0, 20)
					aR:Add(l)

					local m = ab.ViewportTextBox.new()
					m.Position = UDim2.new(0, 75, 0, 10)
					m.Size = UDim2.new(0, 120, 0, 20)
					aR:Add(m, "NameBox")
					m.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
						k:SetDisabled(#m:GetText() == 0)
					end)

					local n = ab.Label.new()
					n.Text = "Type"
					n.Position = UDim2.new(0, 30, 0, 40)
					n.Size = UDim2.new(0, 40, 0, 20)
					aR:Add(n)

					local o = ab.DropDown.new()
					o.CanBeEmpty = false
					o.Position = UDim2.new(0, 75, 0, 40)
					o.Size = UDim2.new(0, 120, 0, 20)
					o:SetOptions(ap.AllowedAttributeTypes)
					aR:Add(o, "TypeChooser")

					local p = ab.Label.new()
					p.Text = ""
					p.Position = UDim2.new(0, 5, 1, -45)
					p.Size = UDim2.new(1, -10, 0, 20)
					p.TextColor3 = ad.Theme.Important
					aR.ErrorLabel = p
					aR:Add(p, "Error")

					local q = ab.Button.new()
					q.Text = "Cancel"
					q.Position = UDim2.new(1, -97, 1, -25)
					q.Size = UDim2.new(0, 92, 0, 20)
					q.OnClick:Connect(function()
						aR:Close()
					end)
					aR:Add(q)

					k.Text = "Save"
					k.Position = UDim2.new(0, 5, 1, -25)
					k.Size = UDim2.new(0, 92, 0, 20)
					k.OnClick:Connect(function()
						local r = m:GetText()
						if #r > 100 then
							p.Text = "Error: Name over 100 chars"
							return
						elseif r:sub(1, 3) == "RBX" then
							p.Text = "Error: Name begins with 'RBX'"
							return
						end

						local s = o.Selected
						local t = { Name = ap.TypeNameConvert[s] or s, Category = "DataType" }
						local u = { IsAttribute = true, Name = "ATTR_" .. r, AttributeName = r, DisplayName = r, Class = "Instance", ValueType = t, Category = "Attributes", Tags = {} }

						ad.Properties.ShowAttributes = true
						ap.SetProp(u, ap.DefaultPropValue[t.Name], true, ap.EditingAttribute)
						ap.ShowExplorerProps()
						aR:Close()
					end)
					aR:Add(k, "SaveButton")

					ap.AddAttributeWindow = aR
				end

				ap.EditingAttribute = aQ
				aR:SetTitle(aQ and "Edit Attribute " .. aQ.AttributeName or "Add Attribute")
				aR.Elements.Error.Text = ""
				aR.Elements.NameBox:SetText("")
				aR.Elements.SaveButton:SetDisabled(true)
				aR.Elements.TypeChooser:SetSelected(1)
				aR:Show()
			end

			ap.IsTextEditable = function(aQ)
				local aR = aQ.ValueType
				local k = aR.Name

				return k ~= "bool" and aR.Category ~= "Enum" and aR.Category ~= "Class" and k ~= "BrickColor"
			end

			ap.DisplayEnumDropdown = function(aQ)
				local aR = ap.EnumContext
				if not aR then
					aR = ab.ContextMenu.new()
					aR.Iconless = true
					aR.MaxHeight = 200
					aR.ReverseYOffset = 22
					ap.EnumDropdown = aR
				end

				if not aF or aF.ValueType.Category ~= "Enum" then
					return
				end
				local k = aF

				local l = aB[aQ]
				local m = l.GuiElems.ValueFrame

				local n = Enum[k.ValueType.Name]
				if not n then
					return
				end

				local o = {}
				for p, q in next, n:GetEnumItems() do
					o[#o + 1] = q
				end
				aI.sort(o, function(p, q)
					return p.Name < q.Name
				end)

				aR:Clear()

				local function onClick(p)
					if k ~= aF then
						return
					end

					local q = n[p]
					aF = nil
					ap.SetProp(k, q)
				end

				for p = 1, #o do
					local q = o[p]
					aR:Add({ Name = q.Name, OnClick = onClick })
				end

				aR.Width = m.AbsoluteSize.X
				aR:Show(m.AbsolutePosition.X, m.AbsolutePosition.Y + 22)
			end

			ap.DisplayBrickColorEditor = function(aQ, aR, k)
				local l = ap.BrickColorEditor
				if not l then
					l = ab.BrickColorPicker.new()
					l.Gui.DisplayOrder = aa.DisplayOrders.Menu
					l.ReverseYOffset = 22

					l.OnSelect:Connect(function(m)
						if not l.CurrentProp or l.CurrentProp.ValueType.Name ~= "BrickColor" then
							return
						end

						if l.CurrentProp == aF then
							aF = nil
						end
						ap.SetProp(l.CurrentProp, BrickColor.new(m))
					end)

					l.OnMoreColors:Connect(function()
						l:Close()
						local m
						for n, o in pairs(ai.Classes.BasePart.Properties) do
							if o.Name == "Color" then
								m = o
								break
							end
						end
						ap.DisplayColorEditor(m, l.SavedColor.Color)
					end)

					ap.BrickColorEditor = l
				end

				local m = aB[aR]
				local n = m.GuiElems.ValueFrame

				l.CurrentProp = aQ
				l.SavedColor = k
				if aQ and aQ.Class == "BasePart" and aQ.Name == "BrickColor" then
					l:SetMoreColorsVisible(true)
				else
					l:SetMoreColorsVisible(false)
				end
				l:Show(n.AbsolutePosition.X, n.AbsolutePosition.Y + 22)
			end

			ap.DisplayColorEditor = function(aQ, aR)
				local k = ap.ColorEditor
				if not k then
					k = ab.ColorPicker.new()

					k.OnSelect:Connect(function(l)
						if not k.CurrentProp then
							return
						end
						local m = k.CurrentProp.ValueType.Name
						if m ~= "Color3" and m ~= "BrickColor" then
							return
						end

						local n = (m == "Color3" and l or BrickColor.new(l))

						if k.CurrentProp == aF then
							aF = nil
						end
						ap.SetProp(k.CurrentProp, n)
					end)

					ap.ColorEditor = k
				end

				k.CurrentProp = aQ
				if aR then
					k:SetColor(aR)
				else
					local l = ap.GetFirstPropVal(aQ)
					if l then
						k:SetColor(l)
					end
				end
				k:Show()
			end

			ap.DisplayNumberSequenceEditor = function(aQ, aR)
				local k = ap.NumberSequenceEditor
				if not k then
					k = ab.NumberSequenceEditor.new()

					k.OnSelect:Connect(function(l)
						if not k.CurrentProp or k.CurrentProp.ValueType.Name ~= "NumberSequence" then
							return
						end

						if k.CurrentProp == aF then
							aF = nil
						end
						ap.SetProp(k.CurrentProp, l)
					end)

					ap.NumberSequenceEditor = k
				end

				k.CurrentProp = aQ
				if aR then
					k:SetSequence(aR)
				else
					local l = ap.GetFirstPropVal(aQ)
					if l then
						k:SetSequence(l)
					end
				end
				k:Show()
			end

			ap.DisplayColorSequenceEditor = function(aQ, aR)
				local k = ap.ColorSequenceEditor
				if not k then
					k = ab.ColorSequenceEditor.new()

					k.OnSelect:Connect(function(l)
						if not k.CurrentProp or k.CurrentProp.ValueType.Name ~= "ColorSequence" then
							return
						end

						if k.CurrentProp == aF then
							aF = nil
						end
						ap.SetProp(k.CurrentProp, l)
					end)

					ap.ColorSequenceEditor = k
				end

				k.CurrentProp = aQ
				if aR then
					k:SetSequence(aR)
				else
					local l = ap.GetFirstPropVal(aQ)
					if l then
						k:SetSequence(l)
					end
				end
				k:Show()
			end

			ap.GetFirstPropVal = function(aQ)
				local aR = ap.FindFirstObjWhichIsA(aQ.Class)
				if aR then
					return ap.GetPropVal(aQ, aR)
				end
			end

			ap.GetPropVal = function(aQ, aR)
				if aQ.MultiType then
					return "<Multiple Types>"
				end
				if not aR then
					return
				end

				local k
				if aQ.IsAttribute then
					k = aN(aR, aQ.AttributeName)
					if k == nil then
						return nil
					end

					local l = typeof(k)
					local m = ap.TypeNameConvert[l] or l
					if aQ.RootType then
						if aQ.RootType.Name ~= m then
							return nil
						end
					elseif aQ.ValueType.Name ~= m then
						return nil
					end
				else
					k = aR[aQ.Name]
				end
				if aQ.SubName then
					local l = aJ.split(aQ.SubName, ".")
					for m = 1, #l do
						local n = l[m]
						if #n > 0 and k then
							k = k[n]
						end
					end
				end

				return k
			end

			ap.SelectObject = function(aQ)
				if aF and aF.ValueType.Category == "Class" then
					local aR = aF
					aF = nil

					if aM(aQ, aR.ValueType.Name) then
						ap.SetProp(aR, aQ)
					else
						ap.Refresh()
					end

					return true
				end

				return false
			end

			ap.DisplayProp = function(aQ, aR)
				local k = aQ.Name
				local l = aQ.ValueType
				local m = l.Name
				local n = aQ.Tags
				local o = aQ.Class .. "." .. aQ.Name .. (aQ.SubName or "")
				local p = aC[o]
				local q = aB[aR]
				local r = UDim2

				local s = q.GuiElems
				local t = s.ValueFrame
				local u = s.ValueBox
				local v = s.ColorButton
				local w = s.ColorPreview
				local x = s.Gradient
				local y = s.EnumArrow
				local z = s.Checkbox
				local A = s.RightButton
				local B = s.SoundPreview

				local C = ap.GetPropVal(aQ, p)
				local D = aF and (aF.Class .. "." .. aF.Name .. (aF.SubName or ""))

				local E = 4
				local F = 6

				if m == "Color3" or m == "BrickColor" or m == "ColorSequence" then
					v.Visible = true
					y.Visible = false
					if C then
						x.Color = (m == "Color3" and ColorSequence.new(C)) or (m == "BrickColor" and ColorSequence.new(C.Color)) or C
					else
						x.Color = ColorSequence.new(Color3.new(1, 1, 1))
					end
					w.BorderColor3 = (m == "ColorSequence" and Color3.new(1, 1, 1) or Color3.new(0, 0, 0))
					E = 22
					F = 24 + (m == "ColorSequence" and 20 or 0)
				elseif l.Category == "Enum" then
					v.Visible = false
					y.Visible = not aQ.Tags.ReadOnly
					F = 22
				elseif (o == D and l.Category == "Class") or m == "NumberSequence" then
					v.Visible = false
					y.Visible = false
					F = 26
				else
					v.Visible = false
					y.Visible = false
				end

				u.Position = r.new(0, E, 0, 0)
				u.Size = r.new(1, -F, 1, 0)

				if D == o and l.Category == "Class" then
					aa.MiscIcons:DisplayByKey(s.RightButtonIcon, "Delete")
					s.RightButtonIcon.Visible = true
					A.Text = ""
					A.Visible = true
				elseif m == "NumberSequence" or m == "ColorSequence" then
					s.RightButtonIcon.Visible = false
					A.Text = "..."
					A.Visible = true
				else
					A.Visible = false
				end

				if m == "bool" or m == "PhysicalProperties" then
					u.Visible = false
					z.Visible = true
					B.Visible = false
					aG[aR].Disabled = n.ReadOnly
					if m == "PhysicalProperties" and aC[o] then
						aG[aR]:SetState(C and true or false)
					else
						aG[aR]:SetState(C)
					end
				elseif m == "SoundPlayer" then
					u.Visible = false
					z.Visible = false
					B.Visible = true
					local G = ap.PreviewSound and ap.PreviewSound.Playing
					aa.MiscIcons:DisplayByKey(B.ControlButton.Icon, G and "Pause" or "Play")
				else
					u.Visible = true
					z.Visible = false
					B.Visible = false

					if C ~= nil then
						if m == "Color3" then
							u.Text = "[" .. ab.ColorToBytes(C) .. "]"
						elseif l.Category == "Enum" then
							u.Text = C.Name
						elseif ap.RoundableTypes[m] and ad.Properties.NumberRounding then
							local G = ap.ValueToString(aQ, C)
							u.Text = G:gsub("-?%d+%.%d+", function(H)
								return tostring(tonumber(("%." .. ad.Properties.NumberRounding .. "f"):format(H)))
							end)
						else
							u.Text = ap.ValueToString(aQ, C)
						end
					else
						u.Text = ""
					end

					u.TextColor3 = n.ReadOnly and ad.Theme.PlaceholderText or ad.Theme.Text
				end
			end

			ap.Refresh = function()
				local aQ = math.max(math.ceil(at.AbsoluteSize.Y / 23), 0)
				local aR = at.AbsoluteSize.X
				local l = math.max(ap.MinInputWidth, aR - ap.ViewWidth)
				local m = false
				local n = game.IsA
				local o = UDim2
				local p = aJ.split
				local q = ad.Properties.ScaleType

				for r = 1, #aH do
					aH[r]:Disconnect()
				end
				aI.clear(aH)

				ap.FullNameFrame.Visible = false
				ap.FullNameFrameAttach.Disable()

				for r = 1, aQ do
					local s = aB[r]
					if not aB[r] then
						s = ap.NewPropEntry(r)
						aB[r] = s
					end

					local t = s.Gui
					local u = s.GuiElems
					local v = u.NameFrame
					local w = u.PropName
					local x = u.ValueFrame
					local y = u.Expand
					local z = u.ValueBox
					local A = u.PropName
					local B = u.RightButton
					local C = u.EditAttributeButton
					local D = u.ToggleAttributes

					local E = ay[r + ap.Index]
					if E then
						local F = (q == 0 and av.Index or 0)
						t.Visible = true
						t.Position = o.new(0, -F, 0, t.Position.Y.Offset)
						t.Size = o.new(q == 0 and 0 or 1, q == 0 and ap.ViewWidth + l or 0, 0, 22)

						if E.SpecialRow then
							if E.SpecialRow == "AddAttribute" then
								v.Visible = false
								x.Visible = false
								u.RowButton.Visible = true
							end
						else
							v.Visible = true
							u.RowButton.Visible = false

							local G = ap.EntryIndent * (E.Depth or 1)
							local H = G + ap.EntryOffset
							v.Position = o.new(0, H, 0, 0)
							w.Size = o.new(1, -2 - (q == 0 and 0 or 6), 1, 0)

							local I = (E.CategoryName and "CAT_" .. E.CategoryName) or E.Class .. "." .. E.Name .. (E.SubName or "")

							if E.CategoryName then
								t.BackgroundColor3 = ad.Theme.Main1
								x.Visible = false

								A.Text = E.CategoryName
								A.Font = Enum.Font.SourceSansBold
								y.Visible = true
								A.TextColor3 = ad.Theme.Text
								v.BackgroundTransparency = 1
								v.Size = o.new(1, 0, 1, 0)
								C.Visible = false

								local J = ad.Properties.ShowAttributes
								D.Position = o.new(1, -85 - H, 0, 0)
								D.Text = (J and "[Setting: ON]" or "[Setting: OFF]")
								D.TextColor3 = ad.Theme.Text
								D.Visible = (E.CategoryName == "Attributes")
							else
								local J = E.Name
								local K = E.ValueType
								local L = K.Name
								local M = E.Tags
								local N = aC[I]

								local O = (E.IsAttribute and 20 or 0)
								C.Visible = (E.IsAttribute and not E.RootType)
								D.Visible = false

								if q == 0 then
									v.Size = o.new(0, ap.ViewWidth - H - 1, 1, 0)
									x.Position = o.new(0, ap.ViewWidth, 0, 0)
									x.Size = o.new(0, l - O, 1, 0)
								else
									v.Size = o.new(0.5, -H - 1, 1, 0)
									x.Position = o.new(0.5, 0, 0, 0)
									x.Size = o.new(0.5, -O, 1, 0)
								end

								local P = p(I, ".")
								A.Text = E.DisplayName or P[#P]
								A.Font = Enum.Font.SourceSans
								t.BackgroundColor3 = ad.Theme.Main2
								x.Visible = true

								y.Visible = K.Category == "DataType" and ap.ExpandableTypes[L] or ap.ExpandableProps[I]
								A.TextColor3 = M.ReadOnly and ad.Theme.PlaceholderText or ad.Theme.Text

								ap.DisplayProp(E, r)
								if N then
									if E.IsAttribute then
										aH[#aH + 1] = aL(N, E.AttributeName):Connect(function()
											ap.DisplayProp(E, r)
										end)
									else
										aH[#aH + 1] = aK(N, J):Connect(function()
											ap.DisplayProp(E, r)
										end)
									end
								end

								local Q = z.Visible
								local R = aF and (aF.Class .. "." .. aF.Name .. (aF.SubName or ""))
								if I == R then
									v.BackgroundColor3 = ad.Theme.ListSelection
									v.BackgroundTransparency = 0
									if K.Category == "Class" or K.Category == "Enum" or L == "BrickColor" then
										x.BackgroundColor3 = ad.Theme.TextBox
										x.BackgroundTransparency = 0
										z.Visible = true
									else
										m = true
										local S = (q == 0 and 0 or 0.5)
										local T = (q == 0 and ap.ViewWidth - av.Index or 0)
										local U = 0

										if L == "Color3" or L == "ColorSequence" then
											T = T + 22
										end

										if L == "NumberSequence" or L == "ColorSequence" then
											U = 20
										end

										aD.Position = o.new(S, T, 0, t.Position.Y.Offset)
										aD.Size = o.new(1 - S, -T - U - O, 0, 22)
										aD.Visible = true
										z.Visible = false
									end
								else
									v.BackgroundColor3 = ad.Theme.Main1
									v.BackgroundTransparency = 1
									x.BackgroundColor3 = ad.Theme.Main1
									x.BackgroundTransparency = 1
									z.Visible = Q
								end
							end

							if E.CategoryName or ap.ExpandableTypes[E.ValueType and E.ValueType.Name] or ap.ExpandableProps[I] then
								if ab.CheckMouseInGui(y) then
									aa.MiscIcons:DisplayByKey(y.Icon, az[I] and "Collapse_Over" or "Expand_Over")
								else
									aa.MiscIcons:DisplayByKey(y.Icon, az[I] and "Collapse" or "Expand")
								end
								y.Visible = true
							else
								y.Visible = false
							end
						end
						t.Visible = true
					else
						t.Visible = false
					end
				end

				if not m then
					aD.Visible = false
				end

				for r = aQ + 1, #aB do
					aB[r].Gui:Destroy()
					aB[r] = nil
					aG[r] = nil
				end
			end

			ap.SetProp = function(aQ, aR, l, m)
				local n = ae.Selection.List
				local o = aQ.Name
				local p = aQ.SubName
				local q = aQ.Class
				local r = aQ.ValueType
				local s = r.Name
				local t = aQ.AttributeName
				local u = aQ.RootType
				local v = u and u.Name
				local w = aQ.Class .. "." .. aQ.Name .. (aQ.SubName or "")
				local x = Vector3

				for y = 1, #n do
					local z = n[y]
					local A = z.Obj

					if aM(A, q) then
						pcall(function()
							local B = aR
							local C
							if aQ.IsAttribute then
								C = aN(A, t)
							else
								C = A[o]
							end

							if m then
								if m.ValueType.Name == s then
									B = aN(A, m.AttributeName) or B
								end
								aO(A, m.AttributeName, nil)
							end

							if v then
								if v == "Vector2" then
									B = Vector2.new((p == ".X" and B) or C.X, (p == ".Y" and B) or C.Y)
								elseif v == "Vector3" then
									B = x.new((p == ".X" and B) or C.X, (p == ".Y" and B) or C.Y, (p == ".Z" and B) or C.Z)
								elseif v == "UDim" then
									B = UDim.new((p == ".Scale" and B) or C.Scale, (p == ".Offset" and B) or C.Offset)
								elseif v == "UDim2" then
									local D, E = C.X, C.Y
									local F = (p == ".X" and B) or UDim.new((p == ".X.Scale" and B) or D.Scale, (p == ".X.Offset" and B) or D.Offset)
									local G = (p == ".Y" and B) or UDim.new((p == ".Y.Scale" and B) or E.Scale, (p == ".Y.Offset" and B) or E.Offset)
									B = UDim2.new(F, G)
								elseif v == "CFrame" then
									local D, E, F, G = C.Position, C.RightVector, C.UpVector, C.LookVector
									local H = (p == ".Position" and B) or x.new((p == ".Position.X" and B) or D.X, (p == ".Position.Y" and B) or D.Y, (p == ".Position.Z" and B) or D.Z)
									local I = (p == ".RightVector" and B) or x.new((p == ".RightVector.X" and B) or E.X, (p == ".RightVector.Y" and B) or E.Y, (p == ".RightVector.Z" and B) or E.Z)
									local J = (p == ".UpVector" and B) or x.new((p == ".UpVector.X" and B) or F.X, (p == ".UpVector.Y" and B) or F.Y, (p == ".UpVector.Z" and B) or F.Z)
									local K = (p == ".LookVector" and B) or x.new((p == ".LookVector.X" and B) or G.X, (p == ".RightVector.Y" and B) or G.Y, (p == ".RightVector.Z" and B) or G.Z)
									B = CFrame.fromMatrix(H, I, J, -K)
								elseif v == "Rect" then
									local D, E = C.Min, C.Max
									local F = Vector2.new((p == ".Min.X" and B) or D.X, (p == ".Min.Y" and B) or D.Y)
									local G = Vector2.new((p == ".Max.X" and B) or E.X, (p == ".Max.Y" and B) or E.Y)
									B = Rect.new(F, G)
								elseif v == "PhysicalProperties" then
									local D = PhysicalProperties.new(A.Material)
									local E = (p == ".Density" and B) or (C and C.Density) or D.Density
									local F = (p == ".Friction" and B) or (C and C.Friction) or D.Friction
									local G = (p == ".Elasticity" and B) or (C and C.Elasticity) or D.Elasticity
									local H = (p == ".FrictionWeight" and B) or (C and C.FrictionWeight) or D.FrictionWeight
									local I = (p == ".ElasticityWeight" and B) or (C and C.ElasticityWeight) or D.ElasticityWeight
									B = PhysicalProperties.new(E, F, G, H, I)
								elseif v == "Ray" then
									local D, E = C.Origin, C.Direction
									local F = (p == ".Origin" and B) or x.new((p == ".Origin.X" and B) or D.X, (p == ".Origin.Y" and B) or D.Y, (p == ".Origin.Z" and B) or D.Z)
									local G = (p == ".Direction" and B) or x.new((p == ".Direction.X" and B) or E.X, (p == ".Direction.Y" and B) or E.Y, (p == ".Direction.Z" and B) or E.Z)
									B = Ray.new(F, G)
								elseif v == "Faces" then
									local D = {}
									local E = { "Back", "Bottom", "Front", "Left", "Right", "Top" }
									for F, G in pairs(E) do
										local H
										if p == "." .. G then
											H = B
										else
											H = C[G]
										end
										if H then
											D[#D + 1] = Enum.NormalId[G]
										end
									end
									B = Faces.new(unpack(D))
								elseif v == "Axes" then
									local D = {}
									local E = { "X", "Y", "Z" }
									for F, G in pairs(E) do
										local H
										if p == "." .. G then
											H = B
										else
											H = C[G]
										end
										if H then
											D[#D + 1] = Enum.Axis[G]
										end
									end
									B = Axes.new(unpack(D))
								elseif v == "NumberRange" then
									B = NumberRange.new(p == ".Min" and B or C.Min, p == ".Max" and B or C.Max)
								end
							end

							if s == "PhysicalProperties" and B then
								B = C or PhysicalProperties.new(A.Material)
							end

							if aQ.IsAttribute then
								aO(A, t, B)
							else
								A[o] = B
							end
						end)
					end
				end

				if not l then
					ap.ComputeConflicts(aQ)
				end
			end

			ap.InitInputBox = function()
				aD = an({
					{ 1, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderSizePixel = 0, Name = "InputBox", Size = UDim2.new(0, 200, 0, 22), Visible = false, ZIndex = 2 } },
					{ 2, "TextBox", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.062745101749897, 0.51764708757401, 1), BorderSizePixel = 0, ClearTextOnFocus = false, Font = 3, Parent = { 1 }, PlaceholderColor3 = Color3.new(0.69803923368454, 0.69803923368454, 0.69803923368454), Position = UDim2.new(0, 3, 0, 0), Size = UDim2.new(1, -6, 1, 0), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 0, ZIndex = 2 } },
				})
				aE = aD.TextBox
				aD.BackgroundColor3 = ad.Theme.TextBox
				aD.Parent = ap.Window.GuiElems.Content.List

				aE.FocusLost:Connect(function()
					if not aF then
						return
					end

					local aQ = aF
					aF = nil
					local aR = ap.StringToValue(aQ, aE.Text)
					if aR then
						ap.SetProp(aQ, aR)
					else
						ap.Refresh()
					end
				end)

				aE.Focused:Connect(function()
					aE.SelectionStart = 1
					aE.CursorPosition = #aE.Text + 1
				end)

				ab.ViewportTextBox.convert(aE)
			end

			ap.SetInputProp = function(aQ, aR, l)
				local m = aQ.ValueType
				local n = m.Name
				local o = aQ.Class .. "." .. aQ.Name .. (aQ.SubName or "")
				local p = aC[o]
				local q = ap.GetPropVal(aQ, p)

				if aQ.Tags.ReadOnly then
					return
				end

				aF = aQ
				if l then
					if l == "color" then
						if n == "Color3" then
							aE.Text = q and ap.ValueToString(aQ, q) or ""
							ap.DisplayColorEditor(aQ, q)
						elseif n == "BrickColor" then
							ap.DisplayBrickColorEditor(aQ, aR, q)
						elseif n == "ColorSequence" then
							aE.Text = q and ap.ValueToString(aQ, q) or ""
							ap.DisplayColorSequenceEditor(aQ, q)
						end
					elseif l == "right" then
						if n == "NumberSequence" then
							aE.Text = q and ap.ValueToString(aQ, q) or ""
							ap.DisplayNumberSequenceEditor(aQ, q)
						elseif n == "ColorSequence" then
							aE.Text = q and ap.ValueToString(aQ, q) or ""
							ap.DisplayColorSequenceEditor(aQ, q)
						end
					end
				else
					if ap.IsTextEditable(aQ) then
						aE.Text = q and ap.ValueToString(aQ, q) or ""
						aE:CaptureFocus()
					elseif m.Category == "Enum" then
						ap.DisplayEnumDropdown(aR)
					elseif n == "BrickColor" then
						ap.DisplayBrickColorEditor(aQ, aR, q)
					end
				end
				ap.Refresh()
			end

			ap.InitSearch = function()
				local aQ = ap.GuiElems.ToolBar.SearchFrame.SearchBox

				ab.ViewportTextBox.convert(aQ)

				aQ:GetPropertyChangedSignal("Text"):Connect(function()
					ap.SearchText = aQ.Text
					ap.Update()
					ap.Refresh()
				end)
			end

			ap.InitEntryStuff = function()
				ap.EntryTemplate = an({
					{ 1, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935), Font = 3, Name = "Entry", Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(0, 250, 0, 22), Text = "", TextSize = 14 } },
					{ 2, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.33725491166115, 0.49019610881805, 0.73725491762161), BorderSizePixel = 0, Name = "NameFrame", Parent = { 1 }, Position = UDim2.new(0, 20, 0, 0), Size = UDim2.new(1, -40, 1, 0) } },
					{ 3, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "PropName", Parent = { 2 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(1, -2, 1, 0), Text = "Anchored", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 0.10000000149012, TextTruncate = 1, TextXAlignment = 0 } },
					{ 4, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Font = 3, Name = "Expand", Parent = { 2 }, Position = UDim2.new(0, -20, 0, 1), Size = UDim2.new(0, 20, 0, 20), Text = "", TextSize = 14, Visible = false } },
					{ 5, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://105964861876010", ImageRectOffset = Vector2.new(144, 16), ImageRectSize = Vector2.new(16, 16), Name = "Icon", Parent = { 4 }, Position = UDim2.new(0, 2, 0, 2), ScaleType = 4, Size = UDim2.new(0, 16, 0, 16) } },
					{ 6, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 4, Name = "ToggleAttributes", Parent = { 2 }, Position = UDim2.new(1, -85, 0, 0), Size = UDim2.new(0, 85, 0, 22), Text = "[SETTING: OFF]", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 0.10000000149012, Visible = false } },
					{ 7, "Frame", { BackgroundColor3 = Color3.new(0.04313725605607, 0.35294118523598, 0.68627452850342), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.33725491166115, 0.49019607901573, 0.73725491762161), BorderSizePixel = 0, Name = "ValueFrame", Parent = { 1 }, Position = UDim2.new(1, -100, 0, 0), Size = UDim2.new(0, 80, 1, 0) } },
					{ 8, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderColor3 = Color3.new(0.33725491166115, 0.49019610881805, 0.73725491762161), BorderSizePixel = 0, Name = "Line", Parent = { 7 }, Position = UDim2.new(0, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0) } },
					{ 9, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "ColorButton", Parent = { 7 }, Size = UDim2.new(0, 20, 0, 22), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, Visible = false } },
					{ 10, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0), Name = "ColorPreview", Parent = { 9 }, Position = UDim2.new(0, 5, 0, 6), Size = UDim2.new(0, 10, 0, 10) } },
					{ 11, "UIGradient", { Parent = { 10 } } },
					{ 12, "Frame", { BackgroundTransparency = 1, Name = "EnumArrow", Parent = { 7 }, Position = UDim2.new(1, -16, 0, 3), Size = UDim2.new(0, 16, 0, 16), Visible = false } },
					{ 13, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 12 }, Position = UDim2.new(0, 8, 0, 9), Size = UDim2.new(0, 1, 0, 1) } },
					{ 14, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 12 }, Position = UDim2.new(0, 7, 0, 8), Size = UDim2.new(0, 3, 0, 1) } },
					{ 15, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 12 }, Position = UDim2.new(0, 6, 0, 7), Size = UDim2.new(0, 5, 0, 1) } },
					{ 16, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "ValueBox", Parent = { 7 }, Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -8, 1, 0), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 0.10000000149012, TextTruncate = 1, TextXAlignment = 0 } },
					{ 17, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "RightButton", Parent = { 7 }, Position = UDim2.new(1, -20, 0, 0), Size = UDim2.new(0, 20, 0, 22), Text = "...", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, Visible = false } },
					{ 18, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "SettingsButton", Parent = { 7 }, Position = UDim2.new(1, -20, 0, 0), Size = UDim2.new(0, 20, 0, 22), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, Visible = false } },
					{ 19, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "SoundPreview", Parent = { 7 }, Size = UDim2.new(1, 0, 1, 0), Visible = false } },
					{ 20, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "ControlButton", Parent = { 19 }, Size = UDim2.new(0, 20, 0, 22), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
					{ 21, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://105964861876010", ImageRectOffset = Vector2.new(144, 16), ImageRectSize = Vector2.new(16, 16), Name = "Icon", Parent = { 20 }, Position = UDim2.new(0, 2, 0, 3), ScaleType = 4, Size = UDim2.new(0, 16, 0, 16) } },
					{ 22, "Frame", { BackgroundColor3 = Color3.new(0.3137255012989, 0.3137255012989, 0.3137255012989), BorderSizePixel = 0, Name = "TimeLine", Parent = { 19 }, Position = UDim2.new(0, 26, 0.5, -1), Size = UDim2.new(1, -34, 0, 2) } },
					{ 23, "Frame", { BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935), Name = "Slider", Parent = { 22 }, Position = UDim2.new(0, -4, 0, -8), Size = UDim2.new(0, 8, 0, 18) } },
					{ 24, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "EditAttributeButton", Parent = { 1 }, Position = UDim2.new(1, -20, 0, 0), Size = UDim2.new(0, 20, 0, 22), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
					{ 25, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://93695922781161", ImageTransparency = 0.20000000298023, Name = "Icon", Parent = { 24 }, Position = UDim2.new(0, 2, 0, 3), Size = UDim2.new(0, 16, 0, 16) } },
					{ 26, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderSizePixel = 0, Font = 3, Name = "RowButton", Parent = { 1 }, Size = UDim2.new(1, 0, 1, 0), Text = "Add Attribute", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 0.10000000149012, Visible = false } },
				})

				local aQ = ab.Frame.new()
				local aR = ab.Label.new()
				aR.Parent = aQ.Gui
				aR.Position = UDim2.new(0, 2, 0, 0)
				aR.Size = UDim2.new(1, -4, 1, 0)
				aQ.Visible = false
				aQ.Parent = aq.Gui

				ap.FullNameFrame = aQ
				ap.FullNameFrameAttach = ab.AttachTo(aQ)
			end

			ap.Init = function()
				local aQ = an({
					{ 1, "Folder", { Name = "Items" } },
					{ 2, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "ToolBar", Parent = { 1 }, Size = UDim2.new(1, 0, 0, 22) } },
					{ 3, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.1176470592618, 0.1176470592618, 0.1176470592618), BorderSizePixel = 0, Name = "SearchFrame", Parent = { 2 }, Position = UDim2.new(0, 3, 0, 1), Size = UDim2.new(1, -6, 0, 18) } },
					{ 4, "TextBox", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ClearTextOnFocus = false, Font = 3, Name = "SearchBox", Parent = { 3 }, PlaceholderColor3 = Color3.new(0.39215689897537, 0.39215689897537, 0.39215689897537), PlaceholderText = "Search properties", Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -24, 0, 18), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 0 } },
					{ 5, "UICorner", { CornerRadius = UDim.new(0, 2), Parent = { 3 } } },
					{ 6, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Reset", Parent = { 3 }, Position = UDim2.new(1, -17, 0, 1), Size = UDim2.new(0, 16, 0, 16), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
					{ 7, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://81560269887102", ImageColor3 = Color3.new(0.39215686917305, 0.39215686917305, 0.39215686917305), Parent = { 6 }, Size = UDim2.new(0, 16, 0, 16) } },
					{ 8, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Refresh", Parent = { 2 }, Position = UDim2.new(1, -20, 0, 1), Size = UDim2.new(0, 18, 0, 18), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, Visible = false } },
					{ 9, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://134503731840902", Parent = { 8 }, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(0, 12, 0, 12) } },
					{ 10, "Frame", { BackgroundColor3 = Color3.new(0.15686275064945, 0.15686275064945, 0.15686275064945), BorderSizePixel = 0, Name = "ScrollCorner", Parent = { 1 }, Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, 16, 0, 16), Visible = false } },
					{ 11, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Name = "List", Parent = { 1 }, Position = UDim2.new(0, 0, 0, 23), Size = UDim2.new(1, 0, 1, -23) } },
				})

				aw = ai.CategoryOrder
				for aR, l in next, aw do
					if not ap.CollapsedCategories[aR] then
						az["CAT_" .. aR] = true
					end
				end
				az["Sound.SoundId"] = true

				aq = ab.Window.new()
				ap.Window = aq
				aq:SetTitle("Properties")

				as = aQ.ToolBar
				at = aQ.List

				ap.GuiElems.ToolBar = as
				ap.GuiElems.PropsFrame = at

				ap.InitEntryStuff()

				aq.GuiElems.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if ap.Window:IsContentVisible() then
						ap.UpdateView()
						ap.Refresh()
					end
				end)
				aq.OnActivate:Connect(function()
					ap.UpdateView()
					ap.Update()
					ap.Refresh()
				end)
				aq.OnRestore:Connect(function()
					ap.UpdateView()
					ap.Update()
					ap.Refresh()
				end)

				au = ab.ScrollBar.new()
				au.WheelIncrement = 3
				au.Gui.Position = UDim2.new(1, -16, 0, 23)
				au:SetScrollFrame(at)
				au.Scrolled:Connect(function()
					ap.Index = au.Index
					ap.Refresh()
				end)

				av = ab.ScrollBar.new(true)
				av.Increment = 5
				av.WheelIncrement = 20
				av.Gui.Position = UDim2.new(0, 0, 1, -16)
				av.Scrolled:Connect(function()
					ap.Refresh()
				end)

				aq.GuiElems.Line.Position = UDim2.new(0, 0, 0, 22)
				as.Parent = aq.GuiElems.Content
				at.Parent = aq.GuiElems.Content
				aQ.ScrollCorner.Parent = aq.GuiElems.Content
				au.Gui.Parent = aq.GuiElems.Content
				av.Gui.Parent = aq.GuiElems.Content
				ap.InitInputBox()
				ap.InitSearch()
			end

			return ap
		end

		return { InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main }
	end,
	ScriptViewer = function()
		local aa, ab, ac, ad
		local ae, af, ag, ah
		local ai, aj, ak, al, am, an, ao

		local function initDeps(ap)
			aa = ap.Main
			ab = ap.Lib
			ac = ap.Apps
			ad = ap.Settings

			ai = ap.API
			aj = ap.RMD
			ak = ap.env
			al = ap.service
			am = ap.plr
			an = ap.create
			ao = ap.createSimple
		end

		local function initAfterMain()
			ae = ac.Explorer
			af = ac.Properties
			ag = ac.ScriptViewer
			ah = ac.Notebook
		end

		local function CountTable(ap)
			local aq, as = 0
			repeat
				as = next(ap, as)
				if as ~= nil then
					aq = aq + 1
				end
			until as == nil
			return aq
		end

		local ap
		local function ParseObject(aq, as, at, au)
			local av = type(aq)
			if av == "string" then
				return as .. string.format("%q", aq)
			elseif av == "nil" then
				return as .. "nil"
			elseif av == "table" then
				if au[aq] then
					return as .. tostring(aq) .. " [recursive table]"
				else
					au[aq] = true
					return as .. ap(aq, at + 1, au)
				end
			elseif av == "userdata" then
				if typeof(aq) == "userdata" then
					return as .. "userdata"
				else
					return as .. tostring(aq)
				end
			else
				return as .. tostring(aq)
			end
		end
		function ap(aq, as, at)
			local au = getrawmetatable(aq)
			local av = {}
			if au and au ~= aq then
				for aw, ax in pairs(au) do
					rawset(av, aw, ax)
					rawset(au, aw, nil)
				end
			end

			at = at or {}
			as = as or 1
			local aw = (at and "{" or "") .. "\n"
			local ax = string.rep("\t", as)
			local function parse(ay, az)
				aw = aw .. ParseObject(ay, ax, as, at) .. " : " .. ParseObject(az, "", as, at) .. "\n"
			end

			if CountTable(aq) ~= #aq then
				table.foreach(aq, parse)
			else
				for ay = 1, select("#", unpack(aq)) do
					parse(ay, aq[ay])
				end
			end

			if au and au ~= aq then
				for ay, az in pairs(av) do
					rawset(au, ay, rawget(av, ay))
				end
			end

			return aw .. string.sub(ax, 1, #ax - 1) .. (at and "}" or "")
		end

		local function main()
			local aq = {}
			local as, at
			local au
			local av

			aq.ViewScript = function(aw)
				local ax, ay = pcall(ak.decompile or function() end, aw)

				if aw.ClassName == "ModuleScript" then
					av = aw
				end

				if not ax or not ay then
					ay, au = "-- DEX - Source failed to decompile", nil
				else
					au = aw
				end
				at:SetText(ay:gsub("\0", "\\0"))
				as:Show()
			end

			aq.Init = function()
				as = ab.Window.new()
				as:SetTitle("Script Viewer")
				as:Resize(500, 400)
				aq.Window = as

				at = ab.CodeFrame.new()
				at.Frame.Position = UDim2.new(0, 0, 0, 20)
				at.Frame.Size = UDim2.new(1, 0, 1, -20)
				at.Frame.Parent = as.GuiElems.Content

				local aw = Instance.new("TextButton", as.GuiElems.Content)
				aw.BackgroundTransparency = 1
				aw.Size = UDim2.new(0.5, 0, 0, 20)
				aw.Text = "Copy to Clipboard"
				aw.TextColor3 = Color3.new(1, 1, 1)

				aw.MouseButton1Click:Connect(function()
					local ax = at:GetText()
					ak.setclipboard(ax)
				end)

				local ax = Instance.new("TextButton", as.GuiElems.Content)
				ax.BackgroundTransparency = 1
				ax.Position = UDim2.new(0.35, 0, 0, 0)
				ax.Size = UDim2.new(0.3, 0, 0, 20)
				ax.Text = "Save to File"
				ax.TextColor3 = Color3.new(1, 1, 1)

				ax.MouseButton1Click:Connect(function()
					local ay = at:GetText()
					local az = "Place_" .. game.PlaceId .. "_Script_" .. os.time() .. ".txt"

					ak.writefile(az, ay)
					if ak.movefileas then
						ak.movefileas(az, ".txt")
					end
				end)

				local ay = Instance.new("TextButton", as.GuiElems.Content)
				ay.BackgroundTransparency = 1
				ay.Position = UDim2.new(0.7, 0, 0, 0)
				ay.Size = UDim2.new(0.3, 0, 0, 20)
				ay.Text = "Copy Values"
				ay.TextColor3 = Color3.new(1, 1, 1)

				ay.MouseButton1Click:Connect(function()
					if av ~= nil then
						pcall(function()
							local az = require(av)

							setclipboard(ap(az))
						end)
					end
				end)
			end

			return aq
		end

		return { InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main }
	end,
	Lib = function()
		local aa, ab, ac, ad
		local ae, af, ag, ah
		local ai, aj, ak, al, am, an, ao

		local function initDeps(ap)
			aa = ap.Main
			ab = ap.Lib
			ac = ap.Apps
			ad = ap.Settings

			ai = ap.API
			aj = ap.RMD
			ak = ap.env
			al = ap.service
			am = ap.plr
			an = ap.create
			ao = ap.createSimple
		end

		local function initAfterMain()
			ae = ac.Explorer
			af = ac.Properties
			ag = ac.ScriptViewer
			ah = ac.Notebook
		end

		local function main()
			local ap = {}

			local aq = al.RunService.RenderStepped
			local as = aq.wait
			local at = newproxy()
			local au = newproxy()

			local function initObj(av, aw)
				local ax = type
				local function copy(ay)
					local az = {}
					for aA, aB in pairs(ay) do
						if aB == au then
							az[aA] = ap.Signal.new()
						elseif ax(aB) == "table" then
							az[aA] = copy(aB)
						else
							az[aA] = aB
						end
					end
					return az
				end

				local ay = copy(av)
				return setmetatable(ay, aw)
			end

			local function getGuiMT(av, aw)
				return {
					__index = function(ax, ay)
						if not av[ay] then
							return aw[ay] or ax.Gui[ay]
						end
					end,
					__newindex = function(ax, ay, az)
						if not av[ay] then
							ax.Gui[ay] = az
						else
							rawset(ax, ay, az)
						end
					end,
				}
			end

			ap.FormatLuaString = (function()
				local av = string
				local aw = av.gsub
				local ax = av.format
				local ay = av.char
				local az = { ['"'] = '\\"', ["\\"] = "\\\\" }
				for aA = 0, 31 do
					az[ay(aA)] = "\\" .. ax("%03d", aA)
				end
				for aA = 127, 255 do
					az[ay(aA)] = "\\" .. ax("%03d", aA)
				end

				return function(aA)
					return aw(aA, '["\\\0-\31\127-\255]', az)
				end
			end)()

			ap.CheckMouseInGui = function(av)
				if av == nil then
					return false
				end
				local aw = aa.Mouse
				local ax = av.AbsolutePosition
				local ay = av.AbsoluteSize

				return aw.X >= ax.X and aw.X < ax.X + ay.X and aw.Y >= ax.Y and aw.Y < ax.Y + ay.Y
			end

			ap.IsShiftDown = function()
				return al.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or al.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
			end

			ap.IsCtrlDown = function()
				return al.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or al.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
			end

			ap.CreateArrow = function(av, aw, ax)
				local ay = aw
				local az = ao("Frame", {
					BackgroundTransparency = 1,
					Name = "Arrow",
					Size = UDim2.new(0, av, 0, av),
				})
				if ax == "up" then
					for aA = 1, aw do
						ao("Frame", {
							BackgroundColor3 = Color3.new(0.8627450980392157, 0.8627450980392157, 0.8627450980392157),
							BorderSizePixel = 0,
							Position = UDim2.new(0, math.floor(av / 2) - (aA - 1), 0, math.floor(av / 2) + aA - math.floor(ay / 2) - 1),
							Size = UDim2.new(0, aA + (aA - 1), 0, 1),
							Parent = az,
						})
					end
					return az
				elseif ax == "down" then
					for aA = 1, aw do
						ao("Frame", {
							BackgroundColor3 = Color3.new(0.8627450980392157, 0.8627450980392157, 0.8627450980392157),
							BorderSizePixel = 0,
							Position = UDim2.new(0, math.floor(av / 2) - (aA - 1), 0, math.floor(av / 2) - aA + math.floor(ay / 2) + 1),
							Size = UDim2.new(0, aA + (aA - 1), 0, 1),
							Parent = az,
						})
					end
					return az
				elseif ax == "left" then
					for aA = 1, aw do
						ao("Frame", {
							BackgroundColor3 = Color3.new(0.8627450980392157, 0.8627450980392157, 0.8627450980392157),
							BorderSizePixel = 0,
							Position = UDim2.new(0, math.floor(av / 2) + aA - math.floor(ay / 2) - 1, 0, math.floor(av / 2) - (aA - 1)),
							Size = UDim2.new(0, 1, 0, aA + (aA - 1)),
							Parent = az,
						})
					end
					return az
				elseif ax == "right" then
					for aA = 1, aw do
						ao("Frame", {
							BackgroundColor3 = Color3.new(0.8627450980392157, 0.8627450980392157, 0.8627450980392157),
							BorderSizePixel = 0,
							Position = UDim2.new(0, math.floor(av / 2) - aA + math.floor(ay / 2) + 1, 0, math.floor(av / 2) - (aA - 1)),
							Size = UDim2.new(0, 1, 0, aA + (aA - 1)),
							Parent = az,
						})
					end
					return az
				end
				error("r u ok")
			end

			ap.ParseXML = (function()
				local av = function()
					local 
av, aw = string, pairs

					av.byte(">", 1)
					local ax = av.byte("/", 1)
					av.byte("D", 1)
					local ay = av.byte("E", 1)

					function parse(az, aA)
						az = az:gsub("<!%-%-(.-)%-%->", "")

						local aB, aC = {}

						if aA then
							local aD = az:find("<[_%w]")
							if aD then
								az:sub(1, aD):gsub("<!ENTITY%s+([_%w]+)%s+(.)(.-)%2", function(aE, aF, aG)
									aB[#aB + 1] = { name = aE, value = aG }
								end)
								aC = createEntityTable(aB)
								az = replaceEntities(az:sub(aD), aC)
							end
						end

						local aD, aE = {}, {}

						local aF = function(aF)
							aF = aF:match("^%s*(.*%S)") or ""
							if #aF ~= 0 then
								aD[#aD + 1] = { text = aF }
							end
						end

						az:gsub("<([?!/]?)([-:_%w]+)%s*(/?>?)([^<]*)", function(aG, aH, aI, aJ)
							if #aG == 0 then
								local aK = {}
								if #aI == 0 then
									local aL = 0
									for aM, aN, aO, aQ, aR in av.gmatch(aJ, "(.-([-_%w]+)%s*=%s*(.)(.-)%3%s*(/?>?))") do
										aL = aL + #aM
										aK[aN] = aQ
										if #aR ~= 0 then
											aJ = aJ:sub(aL + 1)
											aI = aR
											break
										end
									end
								end
								aD[#aD + 1] = { tag = aH, attrs = aK, children = {} }

								if aI:byte(1) ~= ax then
									aE[#aE + 1] = aD
									aD = aD[#aD].children
								end

								aF(aJ)
							elseif "/" == aG then
								aD = aE[#aE]
								aE[#aE] = nil

								aF(aJ)
							elseif "!" == aG then
								if ay == aH:byte(1) then
									aJ:gsub("([_%w]+)%s+(.)(.-)%2", function(aK, aL, aM)
										aB[#aB + 1] = { name = aK, value = aM }
									end, 1)
								end
							end
						end)

						return { children = aD, entities = aB, tentities = aC }
					end

					function parseText(az)
						return parse(az)
					end

					function defaultEntityTable()
						return { quot = '"', apos = "'", lt = "<", gt = ">", amp = "&", tab = "\t", nbsp = " " }
					end

					function replaceEntities(az, aA)
						return az:gsub("&([^;]+);", aA)
					end

					function createEntityTable(az, aA)
						entities = aA or defaultEntityTable()
						for aB, aC in aw(az) do
							aC.value = replaceEntities(aC.value, entities)
							entities[aC.name] = aC.value
						end
						return entities
					end

					return parseText
				end
				local aw = setmetatable({}, { __index = getfenv() })
				setfenv(av, aw)
				return av()
			end)()

			ap.FastWait = function(av)
				if not av then
					return as(aq)
				end
				local aw = tick()
				while tick() - aw < av do
					as(aq)
				end
			end

			ap.ButtonAnim = function(av, aw)
				local ax = false
				local ay = false
				local az = aw and aw.Mode or 1
				local aA = {}

				if az == 2 then
					local aB = aw.LerpTo or Color3.new(0, 0, 0)
					local aC = aw.LerpDelta or 0.2
					aA.StartColor = aw.StartColor or av.BackgroundColor3
					aA.PressColor = aw.PressColor or aA.StartColor:lerp(aB, aC)
					aA.HoverColor = aw.HoverColor or aA.StartColor:lerp(aA.PressColor, 0.6)
					aA.OutlineColor = aw.OutlineColor
				end

				av.InputBegan:Connect(function(aB)
					if ay then
						return
					end
					if aB.UserInputType == Enum.UserInputType.MouseMovement and not ax then
						if az == 1 then
							av.BackgroundTransparency = 0.4
						elseif az == 2 then
							av.BackgroundColor3 = aA.HoverColor
						end
					elseif aB.UserInputType == Enum.UserInputType.MouseButton1 then
						ax = true
						if az == 1 then
							av.BackgroundTransparency = 0
						elseif az == 2 then
							av.BackgroundColor3 = aA.PressColor
							if aA.OutlineColor then
								av.BorderColor3 = aA.PressColor
							end
						end
					end
				end)

				av.InputEnded:Connect(function(aB)
					if ay then
						return
					end
					if aB.UserInputType == Enum.UserInputType.MouseMovement and not ax then
						if az == 1 then
							av.BackgroundTransparency = 1
						elseif az == 2 then
							av.BackgroundColor3 = aA.StartColor
						end
					elseif aB.UserInputType == Enum.UserInputType.MouseButton1 then
						ax = false
						if az == 1 then
							av.BackgroundTransparency = ap.CheckMouseInGui(av) and 0.4 or 1
						elseif az == 2 then
							av.BackgroundColor3 = ap.CheckMouseInGui(av) and aA.HoverColor or aA.StartColor
							if aA.OutlineColor then
								av.BorderColor3 = aA.OutlineColor
							end
						end
					end
				end)

				aA.Disable = function()
					ay = true
					ax = false

					if az == 1 then
						av.BackgroundTransparency = 1
					elseif az == 2 then
						av.BackgroundColor3 = aA.StartColor
					end
				end

				aA.Enable = function()
					ay = false
				end

				return aA
			end

			ap.FindAndRemove = function(av, aw)
				local ax = table.find(av, aw)
				if ax then
					table.remove(av, ax)
				end
			end

			ap.AttachTo = function(av, aw)
				local ax, ay, az, aA, aB, aC, aD
				local aE = false

				local function update()
					if not av or not ax then
						return
					end

					local aF = ax.AbsolutePosition
					local aG = ax.AbsoluteSize
					av.Position = UDim2.new(0, aF.X + ay, 0, aF.Y + az)
					if aC then
						av.Size = UDim2.new(0, aG.X + aA, 0, aG.Y + aB)
					end
				end

				local function setup(aF, aG)
					av = aF
					aG = aG or {}
					ax = aG.Target
					ay = aG.PosOffX or 0
					az = aG.PosOffY or 0
					aA = aG.SizeOffX or 0
					aB = aG.SizeOffY or 0
					aC = aG.Resize or false

					if aD then
						aD:Disconnect()
						aD = nil
					end
					if ax then
						aD = ax.Changed:Connect(function(aH)
							if not aE and aH == "AbsolutePosition" or aH == "AbsoluteSize" then
								update()
							end
						end)
					end

					update()
				end
				setup(av, aw)

				return {
					SetData = function(aF, aG)
						setup(aF, aG)
					end,
					Enable = function()
						aE = false
						update()
					end,
					Disable = function()
						aE = true
					end,
					Destroy = function()
						aD:Disconnect()
						aD = nil
					end,
				}
			end

			ap.ProtectedGuis = {}

			ap.ShowGui = function(av)
				if ak.gethui then
					av.Parent = ak.gethui()
				elseif ak.protectgui then
					ak.protectgui(av)
					av.Parent = aa.GuiHolder
				else
					av.Parent = aa.GuiHolder
				end
			end

			ap.ColorToBytes = function(av)
				local aw = math.round
				return string.format("%d, %d, %d", aw(av.r * 255), aw(av.g * 255), aw(av.b * 255))
			end

			ap.ReadFile = function(av)
				if not ak.readfile then
					return
				end

				local aw, ax = pcall(ak.readfile, av)
				if aw and ax then
					return ax
				end
			end

			ap.DeferFunc = function(av, ...)
				as(aq)
				return av(...)
			end

			ap.LoadCustomAsset = function(av)
				if not ak.getcustomasset or not ak.isfile or not ak.isfile(av) then
					return
				end

				return ak.getcustomasset(av)
			end

			ap.FetchCustomAsset = function(av, aw)
				if not ak.writefile then
					return
				end

				local ax, ay = pcall(game.HttpGet, game, av)
				if not ax then
					return
				end

				ak.writefile(aw, ay)
				return ap.LoadCustomAsset(aw)
			end

			ap.Signal = (function()
				local av = {}

				local aw = function(aw)
					local ax = table.find(aw.Signal.Connections, aw)
					if ax then
						table.remove(aw.Signal.Connections, ax)
					end
				end

				av.Connect = function(ax, ay)
					if type(ay) ~= "function" then
						error("Attempt to connect a non-function")
					end
					local az = {
						Signal = ax,
						Func = ay,
						Disconnect = aw,
					}
					ax.Connections[#ax.Connections + 1] = az
					return az
				end

				av.Fire = function(ax, ...)
					for ay, az in next, ax.Connections do
						xpcall(coroutine.wrap(az.Func), function(aA)
							warn(aA .. "\n" .. debug.traceback())
						end, ...)
					end
				end

				local ax = {
					__index = av,
					__tostring = function(ax)
						return "Signal: " .. tostring(#ax.Connections) .. " Connections"
					end,
				}

				local function new()
					local ay = {}
					ay.Connections = {}

					return setmetatable(ay, ax)
				end

				return { new = new }
			end)()

			ap.Set = (function()
				local av = {}

				av.Add = function(aw, ax)
					if aw.Map[ax] then
						return
					end

					local ay = aw.List
					ay[#ay + 1] = ax
					aw.Map[ax] = true
					aw.Changed:Fire()
				end

				av.AddTable = function(aw, ax)
					local ay
					local az, aA = aw.List, aw.Map
					for aB = 1, #ax do
						local aC = ax[aB]
						if not aA[aC] then
							az[#az + 1] = aC
							aA[aC] = true
							ay = true
						end
					end
					if ay then
						aw.Changed:Fire()
					end
				end

				av.Remove = function(aw, ax)
					if not aw.Map[ax] then
						return
					end

					local ay = aw.List
					local az = table.find(ay, ax)
					if az then
						table.remove(ay, az)
					end
					aw.Map[ax] = nil
					aw.Changed:Fire()
				end

				av.RemoveTable = function(aw, ax)
					local ay
					local az, aA = aw.List, aw.Map
					local aB = {}
					for aC = 1, #ax do
						local aD = ax[aC]
						aA[aD] = nil
						aB[aD] = true
					end

					for aC = #az, 1, -1 do
						local aD = az[aC]
						if aB[aD] then
							table.remove(az, aC)
							ay = true
						end
					end
					if ay then
						aw.Changed:Fire()
					end
				end

				av.Set = function(aw, ax)
					if #aw.List == 1 and aw.List[1] == ax then
						return
					end

					aw.List = { ax }
					aw.Map = { [ax] = true }
					aw.Changed:Fire()
				end

				av.SetTable = function(aw, ax)
					local ay, az = {}, {}
					aw.List, aw.Map = ay, az
					table.move(ax, 1, #ax, 1, ay)
					for aA = 1, #ax do
						az[ax[aA]] = true
					end
					aw.Changed:Fire()
				end

				av.Clear = function(aw)
					if #aw.List == 0 then
						return
					end
					aw.List = {}
					aw.Map = {}
					aw.Changed:Fire()
				end

				local aw = { __index = av }

				local function new()
					local ax = setmetatable({
						List = {},
						Map = {},
						Changed = ap.Signal.new(),
					}, aw)

					return ax
				end

				return { new = new }
			end)()

			ap.IconMap = (function()
				local av = {}

				av.GetLabel = function(aw)
					local ax = Instance.new("ImageLabel")
					aw:SetupLabel(ax)
					return ax
				end

				av.SetupLabel = function(aw, ax)
					ax.BackgroundTransparency = 1
					ax.ImageRectOffset = Vector2.new(0, 0)
					ax.ImageRectSize = Vector2.new(aw.IconSizeX, aw.IconSizeY)
					ax.ScaleType = Enum.ScaleType.Crop
					ax.Size = UDim2.new(0, aw.IconSizeX, 0, aw.IconSizeY)
				end

				av.Display = function(aw, ax, ay)
					ax.Image = aw.MapId
					if not aw.NumX then
						ax.ImageRectOffset = Vector2.new(aw.IconSizeX * ay, 0)
					else
						ax.ImageRectOffset = Vector2.new(aw.IconSizeX * (ay % aw.NumX), aw.IconSizeY * math.floor(ay / aw.NumX))
					end
				end

				av.DisplayByKey = function(aw, ax, ay)
					if aw.IndexDict[ay] then
						aw:Display(ax, aw.IndexDict[ay])
					end
				end

				av.SetDict = function(aw, ax)
					aw.IndexDict = ax
				end

				local aw = {}
				aw.__index = av

				local function new(ax, ay, az, aA, aB)
					local aC = setmetatable({
						MapId = ax,
						MapSizeX = ay,
						MapSizeY = az,
						IconSizeX = aA,
						IconSizeY = aB,
						NumX = ay / aA,
						IndexDict = {},
					}, aw)
					return aC
				end

				local function newLinear(ax, ay, az)
					local aA = setmetatable({
						MapId = ax,
						IconSizeX = ay,
						IconSizeY = az,
						IndexDict = {},
					}, aw)
					return aA
				end

				return { new = new, newLinear = newLinear }
			end)()

			ap.ScrollBar = (function()
				local av = {}
				local aw = al.UserInputService
				local ax = am:GetMouse()
				local ay = ap.CheckMouseInGui
				local az = ap.CreateArrow

				local function drawThumb(aA)
					local aB = aA.TotalSpace
					local aC = aA.VisibleSpace
					local aD = aA.Index
					local aE = aA.GuiElems.ScrollThumb
					local aF = aA.GuiElems.ScrollThumbFrame

					if not (aA:CanScrollUp() or aA:CanScrollDown()) then
						aE.Visible = false
					else
						aE.Visible = true
					end

					if aA.Horizontal then
						aE.Size = UDim2.new(aC / aB, 0, 1, 0)
						if aE.AbsoluteSize.X < 16 then
							aE.Size = UDim2.new(0, 16, 1, 0)
						end
						local aG = aF.AbsoluteSize.X
						local aH = aE.AbsoluteSize.X
						aE.Position = UDim2.new(aA:GetScrollPercent() * (aG - aH) / aG, 0, 0, 0)
					else
						aE.Size = UDim2.new(1, 0, aC / aB, 0)
						if aE.AbsoluteSize.Y < 16 then
							aE.Size = UDim2.new(1, 0, 0, 16)
						end
						local aG = aF.AbsoluteSize.Y
						local aH = aE.AbsoluteSize.Y
						aE.Position = UDim2.new(0, 0, aA:GetScrollPercent() * (aG - aH) / aG, 0)
					end
				end

				local function createFrame(aA)
					local aB = ao("Frame", { Style = 0, Active = true, AnchorPoint = Vector2.new(0, 0), BackgroundColor3 = Color3.new(0.35294118523598, 0.35294118523598, 0.35294118523598), BackgroundTransparency = 0, BorderColor3 = Color3.new(0.10588236153126, 0.16470588743687, 0.20784315466881), BorderSizePixel = 0, ClipsDescendants = false, Draggable = false, Position = UDim2.new(1, -16, 0, 0), Rotation = 0, Selectable = false, Size = UDim2.new(0, 16, 1, 0), SizeConstraint = 0, Visible = true, ZIndex = 1, Name = "ScrollBar" })
					local aC
					local aD

					if aA.Horizontal then
						aB.Size = UDim2.new(1, 0, 0, 16)
						aC = ao("ImageButton", {
							Parent = aB,
							Name = "Left",
							Size = UDim2.new(0, 16, 0, 16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false,
						})
						az(16, 4, "left").Parent = aC
						aD = ao("ImageButton", {
							Parent = aB,
							Name = "Right",
							Position = UDim2.new(1, -16, 0, 0),
							Size = UDim2.new(0, 16, 0, 16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false,
						})
						az(16, 4, "right").Parent = aD
					else
						aB.Size = UDim2.new(0, 16, 1, 0)
						aC = ao("ImageButton", {
							Parent = aB,
							Name = "Up",
							Size = UDim2.new(0, 16, 0, 16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false,
						})
						az(16, 4, "up").Parent = aC
						aD = ao("ImageButton", {
							Parent = aB,
							Name = "Down",
							Position = UDim2.new(0, 0, 1, -16),
							Size = UDim2.new(0, 16, 0, 16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false,
						})
						az(16, 4, "down").Parent = aD
					end

					local aE = ao("Frame", {
						BackgroundTransparency = 1,
						Parent = aB,
					})
					if aA.Horizontal then
						aE.Position = UDim2.new(0, 16, 0, 0)
						aE.Size = UDim2.new(1, -32, 1, 0)
					else
						aE.Position = UDim2.new(0, 0, 0, 16)
						aE.Size = UDim2.new(1, 0, 1, -32)
					end

					local aF = ao("Frame", {
						BackgroundColor3 = Color3.new(0.47058823529411764, 0.47058823529411764, 0.47058823529411764),
						BorderSizePixel = 0,
						Parent = aE,
					})

					local aG = ao("Frame", {
						BackgroundTransparency = 1,
						Name = "Markers",
						Size = UDim2.new(1, 0, 1, 0),
						Parent = aE,
					})

					local aH = false
					local aI = false
					local aJ = false

					aC.InputBegan:Connect(function(aK)
						if aK.UserInputType == Enum.UserInputType.MouseMovement and not aH and aA:CanScrollUp() then
							aC.BackgroundTransparency = 0.8
						end
						if aK.UserInputType ~= Enum.UserInputType.MouseButton1 or not aA:CanScrollUp() then
							return
						end
						aH = true
						aC.BackgroundTransparency = 0.5
						if aA:CanScrollUp() then
							aA:ScrollUp()
							aA.Scrolled:Fire()
						end
						local aL = tick()
						local aM
						aM = aw.InputEnded:Connect(function(aN)
							if aN.UserInputType ~= Enum.UserInputType.MouseButton1 then
								return
							end
							aM:Disconnect()
							if ay(aC) and aA:CanScrollUp() then
								aC.BackgroundTransparency = 0.8
							else
								aC.BackgroundTransparency = 1
							end
							aH = false
						end)
						while aH do
							if tick() - aL >= 0.3 and aA:CanScrollUp() then
								aA:ScrollUp()
								aA.Scrolled:Fire()
							end
							wait()
						end
					end)
					aC.InputEnded:Connect(function(aK)
						if aK.UserInputType == Enum.UserInputType.MouseMovement and not aH then
							aC.BackgroundTransparency = 1
						end
					end)
					aD.InputBegan:Connect(function(aK)
						if aK.UserInputType == Enum.UserInputType.MouseMovement and not aH and aA:CanScrollDown() then
							aD.BackgroundTransparency = 0.8
						end
						if aK.UserInputType ~= Enum.UserInputType.MouseButton1 or not aA:CanScrollDown() then
							return
						end
						aH = true
						aD.BackgroundTransparency = 0.5
						if aA:CanScrollDown() then
							aA:ScrollDown()
							aA.Scrolled:Fire()
						end
						local aL = tick()
						local aM
						aM = aw.InputEnded:Connect(function(aN)
							if aN.UserInputType ~= Enum.UserInputType.MouseButton1 then
								return
							end
							aM:Disconnect()
							if ay(aD) and aA:CanScrollDown() then
								aD.BackgroundTransparency = 0.8
							else
								aD.BackgroundTransparency = 1
							end
							aH = false
						end)
						while aH do
							if tick() - aL >= 0.3 and aA:CanScrollDown() then
								aA:ScrollDown()
								aA.Scrolled:Fire()
							end
							wait()
						end
					end)
					aD.InputEnded:Connect(function(aK)
						if aK.UserInputType == Enum.UserInputType.MouseMovement and not aH then
							aD.BackgroundTransparency = 1
						end
					end)

					aF.InputBegan:Connect(function(aK)
						if aK.UserInputType == Enum.UserInputType.MouseMovement and not aI then
							aF.BackgroundTransparency = 0.2
							aF.BackgroundColor3 = aA.ThumbSelectColor
						end
						if aK.UserInputType ~= Enum.UserInputType.MouseButton1 then
							return
						end

						local aL = aA.Horizontal and "X" or "Y"
						local aM

						aH = false
						aJ = false
						aI = true
						aF.BackgroundTransparency = 0
						local aN = ax[aL] - aF.AbsolutePosition[aL]
						local aO = ax[aL]
						local aQ
						local aR
						aQ = aw.InputEnded:Connect(function(l)
							if l.UserInputType ~= Enum.UserInputType.MouseButton1 then
								return
							end
							aQ:Disconnect()
							if aR then
								aR:Disconnect()
							end
							if ay(aF) then
								aF.BackgroundTransparency = 0.2
							else
								aF.BackgroundTransparency = 0
								aF.BackgroundColor3 = aA.ThumbColor
							end
							aI = false
						end)
						aA:Update()

						aR = aw.InputChanged:Connect(function(l)
							if l.UserInputType == Enum.UserInputType.MouseMovement and aI and aQ.Connected then
								local m = aE.AbsoluteSize[aL] - aF.AbsoluteSize[aL]
								local n = ax[aL] - aE.AbsolutePosition[aL] - aN
								if n > m then
									n = m
								elseif n < 0 then
									n = 0
								end
								if aM ~= n then
									aM = n
									aA:ScrollTo(math.floor(0.5 + n / m * (aA.TotalSpace - aA.VisibleSpace)))
								end
								wait()
							end
						end)
					end)
					aF.InputEnded:Connect(function(aK)
						if aK.UserInputType == Enum.UserInputType.MouseMovement and not aI then
							aF.BackgroundTransparency = 0
							aF.BackgroundColor3 = aA.ThumbColor
						end
					end)
					aE.InputBegan:Connect(function(aK)
						if aK.UserInputType ~= Enum.UserInputType.MouseButton1 or ay(aF) then
							return
						end

						local aL = aA.Horizontal and "X" or "Y"
						local aM = 0
						if ax[aL] >= aF.AbsolutePosition[aL] + aF.AbsoluteSize[aL] then
							aM = 1
						end

						local function doTick()
							local aN = aA.VisibleSpace - 1
							if aM == 0 and ax[aL] < aF.AbsolutePosition[aL] then
								aA:ScrollTo(aA.Index - aN)
							elseif aM == 1 and ax[aL] >= aF.AbsolutePosition[aL] + aF.AbsoluteSize[aL] then
								aA:ScrollTo(aA.Index + aN)
							end
						end

						aI = false
						aJ = true
						doTick()
						local aN = tick()
						local aO
						aO = aw.InputEnded:Connect(function(aQ)
							if aQ.UserInputType ~= Enum.UserInputType.MouseButton1 then
								return
							end
							aO:Disconnect()
							aJ = false
						end)
						while aJ do
							if tick() - aN >= 0.3 and ay(aE) then
								doTick()
							end
							wait()
						end
					end)

					aB.MouseWheelForward:Connect(function()
						aA:ScrollTo(aA.Index - aA.WheelIncrement)
					end)

					aB.MouseWheelBackward:Connect(function()
						aA:ScrollTo(aA.Index + aA.WheelIncrement)
					end)

					aA.GuiElems.ScrollThumb = aF
					aA.GuiElems.ScrollThumbFrame = aE
					aA.GuiElems.Button1 = aC
					aA.GuiElems.Button2 = aD
					aA.GuiElems.MarkerFrame = aG

					return aB
				end

				av.Update = function(aA, aB)
					local aC = aA.TotalSpace
					local aD = aA.VisibleSpace
					local aE = aA.Index
					local aF = aA.GuiElems.Button1
					local aG = aA.GuiElems.Button2

					aA.Index = math.clamp(aA.Index, 0, math.max(0, aC - aD))

					if aA.LastTotalSpace ~= aA.TotalSpace then
						aA.LastTotalSpace = aA.TotalSpace
						aA:UpdateMarkers()
					end

					if aA:CanScrollUp() then
						for aH, aI in pairs(aF.Arrow:GetChildren()) do
							aI.BackgroundTransparency = 0
						end
					else
						aF.BackgroundTransparency = 1
						for aH, aI in pairs(aF.Arrow:GetChildren()) do
							aI.BackgroundTransparency = 0.5
						end
					end
					if aA:CanScrollDown() then
						for aH, aI in pairs(aG.Arrow:GetChildren()) do
							aI.BackgroundTransparency = 0
						end
					else
						aG.BackgroundTransparency = 1
						for aH, aI in pairs(aG.Arrow:GetChildren()) do
							aI.BackgroundTransparency = 0.5
						end
					end

					drawThumb(aA)
				end

				av.UpdateMarkers = function(aA)
					local aB = aA.GuiElems.MarkerFrame
					aB:ClearAllChildren()

					for aC, aD in pairs(aA.Markers) do
						if aC < aA.TotalSpace then
							ao("Frame", {
								BackgroundTransparency = 0,
								BackgroundColor3 = aD,
								BorderSizePixel = 0,
								Position = aA.Horizontal and UDim2.new(aC / aA.TotalSpace, 0, 1, -6) or UDim2.new(1, -6, aC / aA.TotalSpace, 0),
								Size = aA.Horizontal and UDim2.new(0, 1, 0, 6) or UDim2.new(0, 6, 0, 1),
								Name = "Marker" .. tostring(aC),
								Parent = aB,
							})
						end
					end
				end

				av.AddMarker = function(aA, aB, aC)
					aA.Markers[aB] = aC or Color3.new(0, 0, 0)
				end
				av.ScrollTo = function(aA, aB, aC)
					aA.Index = aB
					aA:Update()
					if not aC then
						aA.Scrolled:Fire()
					end
				end
				av.ScrollUp = function(aA)
					aA.Index = aA.Index - aA.Increment
					aA:Update()
				end
				av.ScrollDown = function(aA)
					aA.Index = aA.Index + aA.Increment
					aA:Update()
				end
				av.CanScrollUp = function(aA)
					return aA.Index > 0
				end
				av.CanScrollDown = function(aA)
					return aA.Index + aA.VisibleSpace < aA.TotalSpace
				end
				av.GetScrollPercent = function(aA)
					return aA.Index / (aA.TotalSpace - aA.VisibleSpace)
				end
				av.SetScrollPercent = function(aA, aB)
					aA.Index = math.floor(aB * (aA.TotalSpace - aA.VisibleSpace))
					aA:Update()
				end

				av.Texture = function(aA, aB)
					aA.ThumbColor = aB.ThumbColor or Color3.new(0, 0, 0)
					aA.ThumbSelectColor = aB.ThumbSelectColor or Color3.new(0, 0, 0)
					aA.GuiElems.ScrollThumb.BackgroundColor3 = aB.ThumbColor or Color3.new(0, 0, 0)
					aA.Gui.BackgroundColor3 = aB.FrameColor or Color3.new(0, 0, 0)
					aA.GuiElems.Button1.BackgroundColor3 = aB.ButtonColor or Color3.new(0, 0, 0)
					aA.GuiElems.Button2.BackgroundColor3 = aB.ButtonColor or Color3.new(0, 0, 0)
					for aC, aD in pairs(aA.GuiElems.Button1.Arrow:GetChildren()) do
						aD.BackgroundColor3 = aB.ArrowColor or Color3.new(0, 0, 0)
					end
					for aC, aD in pairs(aA.GuiElems.Button2.Arrow:GetChildren()) do
						aD.BackgroundColor3 = aB.ArrowColor or Color3.new(0, 0, 0)
					end
				end

				av.SetScrollFrame = function(aA, aB)
					if aA.ScrollUpEvent then
						aA.ScrollUpEvent:Disconnect()
						aA.ScrollUpEvent = nil
					end
					if aA.ScrollDownEvent then
						aA.ScrollDownEvent:Disconnect()
						aA.ScrollDownEvent = nil
					end
					aA.ScrollUpEvent = aB.MouseWheelForward:Connect(function()
						aA:ScrollTo(aA.Index - aA.WheelIncrement)
					end)
					aA.ScrollDownEvent = aB.MouseWheelBackward:Connect(function()
						aA:ScrollTo(aA.Index + aA.WheelIncrement)
					end)
				end

				local aA = {}
				aA.__index = av

				local function new(aB)
					local aC = setmetatable({
						Index = 0,
						VisibleSpace = 0,
						TotalSpace = 0,
						Increment = 1,
						WheelIncrement = 1,
						Markers = {},
						GuiElems = {},
						Horizontal = aB,
						LastTotalSpace = 0,
						Scrolled = ap.Signal.new(),
					}, aA)
					aC.Gui = createFrame(aC)
					aC:Texture({
						ThumbColor = Color3.fromRGB(60, 60, 60),
						ThumbSelectColor = Color3.fromRGB(75, 75, 75),
						ArrowColor = Color3.new(1, 1, 1),
						FrameColor = Color3.fromRGB(40, 40, 40),
						ButtonColor = Color3.fromRGB(75, 75, 75),
					})
					return aC
				end

				return { new = new }
			end)()

			ap.Window = (function()
				local av = {}
				local aw = { MinWidth = 200, FreeWidth = 200 }
				local ax = am:GetMouse()
				local ay, az
				local aA = {}
				local aB = { Width = 300, Windows = {}, ResizeCons = {}, Hidden = true }
				local aC = { Width = 300, Windows = {}, ResizeCons = {}, Hidden = true }

				local aD
				local aE
				local aF = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local aG = {}
				local aH = game.IsA

				local aI = {
					MainColor1 = Color3.fromRGB(52, 52, 52),
					MainColor2 = Color3.fromRGB(45, 45, 45),
					Button = Color3.fromRGB(60, 60, 60),
				}

				local function stopTweens()
					for aJ = 1, #aG do
						aG[aJ]:Cancel()
					end
					aG = {}
				end

				local function resizeHook(aJ, aK, aL)
					local aM = aJ.GuiElems.Main
					aK.InputBegan:Connect(function(aN)
						if not aJ.Dragging and not aJ.Resizing and aJ.Resizable and aJ.ResizableInternal then
							local aO = aL:find("[WE]") and true
							local aQ = aL:find("[NS]") and true
							local aR = aL:find("W", 1, true) and -1 or 1
							local l = aL:find("N", 1, true) and -1 or 1

							if aJ.Minimized and aQ then
								return
							end

							if aN.UserInputType == Enum.UserInputType.MouseMovement then
								aK.BackgroundTransparency = 0.5
							elseif aN.UserInputType == Enum.UserInputType.MouseButton1 then
								local m, n

								local o = ax.X - aK.AbsolutePosition.X
								local p = ax.Y - aK.AbsolutePosition.Y

								aJ.Resizing = aK
								aK.BackgroundTransparency = 1

								m = al.UserInputService.InputEnded:Connect(function(q)
									if q.UserInputType == Enum.UserInputType.MouseButton1 then
										m:Disconnect()
										n:Disconnect()
										aJ.Resizing = false
										aK.BackgroundTransparency = 1
									end
								end)

								n = al.UserInputService.InputChanged:Connect(function(q)
									if aJ.Resizable and aJ.ResizableInternal and q.UserInputType == Enum.UserInputType.MouseMovement then
										aJ:StopTweens()
										local r = q.Position.X - aK.AbsolutePosition.X - o
										local s = q.Position.Y - aK.AbsolutePosition.Y - p

										if aM.AbsoluteSize.X + r * aR < aJ.MinX then
											r = aR * (aJ.MinX - aM.AbsoluteSize.X)
										end
										if aM.AbsoluteSize.Y + s * l < aJ.MinY then
											s = l * (aJ.MinY - aM.AbsoluteSize.Y)
										end
										if l < 0 and aM.AbsolutePosition.Y + s < 0 then
											s = -aM.AbsolutePosition.Y
										end

										aM.Position = aM.Position + UDim2.new(0, (aR < 0 and r or 0), 0, (l < 0 and s or 0))
										aJ.SizeX = aJ.SizeX + (aO and r * aR or 0)
										aJ.SizeY = aJ.SizeY + (aQ and s * l or 0)
										aM.Size = UDim2.new(0, aJ.SizeX, 0, aJ.Minimized and 20 or aJ.SizeY)
									end
								end)
							end
						end
					end)

					aK.InputEnded:Connect(function(aN)
						if aN.UserInputType == Enum.UserInputType.MouseMovement and aJ.Resizing ~= aK then
							aK.BackgroundTransparency = 1
						end
					end)
				end

				local aJ

				local function moveToTop(aK)
					local aL = table.find(aA, aK)
					if aL then
						table.remove(aA, aL)
						table.insert(aA, 1, aK)
						aJ()
					end
				end

				local function sideHasRoom(aK, aL)
					local aM = ay.AbsoluteSize.Y - (math.max(0, #aK.Windows - 1) * 4)
					local aN = 0
					for aO, aQ in pairs(aK.Windows) do
						aN = aN + (aQ.MinY or 100)
						if aN > aM - aL then
							return false
						end
					end

					return true
				end

				local function getSideInsertPos(aK, aL)
					local aM = #aK.Windows + 1
					local aN = { 0, ay.AbsoluteSize.Y }

					for aO, aQ in pairs(aK.Windows) do
						local aR = aQ.PosY + aQ.SizeY / 2
						if aL <= aR then
							aM = aO
							aN[2] = aR
							break
						else
							aN[1] = aR
						end
					end

					return aM, aN
				end

				local function focusInput(aK, aL)
					if aH(aL, "GuiButton") then
						aL.MouseButton1Down:Connect(function()
							moveToTop(aK)
						end)
					elseif aH(aL, "TextBox") then
						aL.Focused:Connect(function()
							moveToTop(aK)
						end)
					end
				end

				local aK = function(aK)
					local aL = an({
						{ 1, "ScreenGui", { Name = "Window" } },
						{ 2, "Frame", { Active = true, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Main", Parent = { 1 }, Position = UDim2.new(0.40000000596046, 0, 0.40000000596046, 0), Size = UDim2.new(0, 300, 0, 300) } },
						{ 3, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0, Name = "Content", Parent = { 2 }, Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 1, -20), ClipsDescendants = true } },
						{ 4, "Frame", { BackgroundColor3 = Color3.fromRGB(33, 33, 33), BorderSizePixel = 0, Name = "Line", Parent = { 3 }, Size = UDim2.new(1, 0, 0, 1) } },
						{ 5, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "TopBar", Parent = { 2 }, Size = UDim2.new(1, 0, 0, 20) } },
						{ 6, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 5 }, Position = UDim2.new(0, 5, 0, 0), Size = UDim2.new(1, -10, 0, 20), Text = "Window", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 0 } },
						{ 7, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Close", Parent = { 5 }, Position = UDim2.new(1, -18, 0, 2), Size = UDim2.new(0, 16, 0, 16), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
						{ 8, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://105239495595666", Parent = { 7 }, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(0, 10, 0, 10) } },
						{ 9, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 7 } } },
						{ 10, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Minimize", Parent = { 5 }, Position = UDim2.new(1, -36, 0, 2), Size = UDim2.new(0, 16, 0, 16), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
						{ 11, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://93909547913779", Parent = { 10 }, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(0, 10, 0, 10) } },
						{ 12, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 10 } } },
						{ 13, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = "rbxassetid://115413171231136", Name = "Outlines", Parent = { 2 }, Position = UDim2.new(0, -5, 0, -5), ScaleType = 1, Size = UDim2.new(1, 10, 1, 10), SliceCenter = Rect.new(6, 6, 25, 25), TileSize = UDim2.new(0, 20, 0, 20) } },
						{ 14, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "ResizeControls", Parent = { 2 }, Position = UDim2.new(0, -5, 0, -5), Size = UDim2.new(1, 10, 1, 10) } },
						{ 15, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "North", Parent = { 14 }, Position = UDim2.new(0, 5, 0, 0), Size = UDim2.new(1, -10, 0, 5), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 16, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "South", Parent = { 14 }, Position = UDim2.new(0, 5, 1, -5), Size = UDim2.new(1, -10, 0, 5), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 17, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "NorthEast", Parent = { 14 }, Position = UDim2.new(1, -5, 0, 0), Size = UDim2.new(0, 5, 0, 5), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 18, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "East", Parent = { 14 }, Position = UDim2.new(1, -5, 0, 5), Size = UDim2.new(0, 5, 1, -10), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 19, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "West", Parent = { 14 }, Position = UDim2.new(0, 0, 0, 5), Size = UDim2.new(0, 5, 1, -10), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 20, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "SouthEast", Parent = { 14 }, Position = UDim2.new(1, -5, 1, -5), Size = UDim2.new(0, 5, 0, 5), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 21, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "NorthWest", Parent = { 14 }, Size = UDim2.new(0, 5, 0, 5), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 22, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "SouthWest", Parent = { 14 }, Position = UDim2.new(0, 0, 1, -5), Size = UDim2.new(0, 5, 0, 5), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
					})

					local aM = aL.Main
					local aN = aM.TopBar
					local aO = aM.ResizeControls

					aK.GuiElems.Main = aM
					aK.GuiElems.TopBar = aM.TopBar
					aK.GuiElems.Content = aM.Content
					aK.GuiElems.Line = aM.Content.Line
					aK.GuiElems.Outlines = aM.Outlines
					aK.GuiElems.Title = aN.Title
					aK.GuiElems.Close = aN.Close
					aK.GuiElems.Minimize = aN.Minimize
					aK.GuiElems.ResizeControls = aO
					aK.ContentPane = aM.Content

					aN.InputBegan:Connect(function(aQ)
						if aQ.UserInputType == Enum.UserInputType.MouseButton1 and aK.Draggable then
							local aR, l

							local m = ay.AbsoluteSize.X
							local n = aM.AbsolutePosition.X
							local o = aM.AbsolutePosition.Y
							local p = ax.X - n
							local q = ax.Y - o

							local r, s

							guiDragging = true

							aR = i(game:GetService("UserInputService")).InputEnded:Connect(function(t)
								if t.UserInputType == Enum.UserInputType.MouseButton1 then
									aR:Disconnect()
									l:Disconnect()
									guiDragging = false
									az.Parent = nil
									if s then
										local u = (s == "left" and aB) or (s == "right" and aC)
										aK:AlignTo(u, r)
									end
								end
							end)

							l = i(game:GetService("UserInputService")).InputChanged:Connect(function(t)
								if t.UserInputType == Enum.UserInputType.MouseMovement and aK.Draggable and not aK.Closed then
									if aK.Aligned then
										if aB.Resizing or aC.Resizing then
											return
										end
										local u, v = t.Position.X - p, t.Position.Y - q
										local w = math.sqrt((u - n) ^ 2 + (v - o) ^ 2)
										if w >= 5 then
											aK:SetAligned(false)
										end
									else
										local u, v = t.Position.X, t.Position.Y
										local w, x = u - p, v - q
										if x < 0 then
											x = 0
										end
										aM.Position = UDim2.new(0, w, 0, x)

										if aK.Resizable and aK.Alignable then
											if u < 25 then
												if sideHasRoom(aB, aK.MinY or 100) then
													local y, z = getSideInsertPos(aB, v)
													az.Indicator.Position = UDim2.new(0, -15, 0, z[1])
													az.Indicator.Size = UDim2.new(0, 40, 0, z[2] - z[1])
													ap.ShowGui(az)
													r = y
													s = "left"
													return
												end
											elseif u >= m - 25 then
												if sideHasRoom(aC, aK.MinY or 100) then
													local y, z = getSideInsertPos(aC, v)
													az.Indicator.Position = UDim2.new(0, m - 25, 0, z[1])
													az.Indicator.Size = UDim2.new(0, 40, 0, z[2] - z[1])
													ap.ShowGui(az)
													r = y
													s = "right"
													return
												end
											end
										end
										az.Parent = nil
										r = nil
										s = nil
									end
								end
							end)
						end
					end)

					aN.Close.MouseButton1Click:Connect(function()
						if aK.Closed then
							return
						end
						aK:Close()
					end)

					aN.Minimize.MouseButton1Click:Connect(function()
						if aK.Closed then
							return
						end
						if aK.Aligned then
							aK:SetAligned(false)
						else
							aK:SetMinimized()
						end
					end)

					aN.Minimize.MouseButton2Click:Connect(function()
						if aK.Closed then
							return
						end
						if not aK.Aligned then
							aK:SetMinimized(nil, 2)
							aN.Minimize.BackgroundTransparency = 1
						end
					end)

					aM.InputBegan:Connect(function(aQ)
						if aQ.UserInputType == Enum.UserInputType.MouseButton1 and not aK.Aligned and not aK.Closed then
							moveToTop(aK)
						end
					end)

					aM:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
						local aQ = aM.AbsolutePosition
						aK.PosX = aQ.X
						aK.PosY = aQ.Y
					end)

					resizeHook(aK, aO.North, "N")
					resizeHook(aK, aO.NorthEast, "NE")
					resizeHook(aK, aO.East, "E")
					resizeHook(aK, aO.SouthEast, "SE")
					resizeHook(aK, aO.South, "S")
					resizeHook(aK, aO.SouthWest, "SW")
					resizeHook(aK, aO.West, "W")
					resizeHook(aK, aO.NorthWest, "NW")

					aM.Size = UDim2.new(0, aK.SizeX, 0, aK.SizeY)

					aL.DescendantAdded:Connect(function(aQ)
						focusInput(aK, aQ)
					end)
					local aQ = aL:GetDescendants()
					for aR = 1, #aQ do
						focusInput(aK, aQ[aR])
					end

					aK.MinimizeAnim = ap.ButtonAnim(aN.Minimize)
					aK.CloseAnim = ap.ButtonAnim(aN.Close)

					return aL
				end

				local function updateSideFrames(aL)
					stopTweens()
					aB.Frame.Size = UDim2.new(0, aB.Width, 1, 0)
					aC.Frame.Size = UDim2.new(0, aC.Width, 1, 0)
					aB.Frame.Resizer.Position = UDim2.new(0, aB.Width, 0, 0)
					aC.Frame.Resizer.Position = UDim2.new(0, -5, 0, 0)

					local aM = #aB.Windows == 0 or aB.Hidden
					local aN = #aC.Windows == 0 or aC.Hidden
					local aO = (aM and UDim2.new(0, -aB.Width - 10, 0, 0) or UDim2.new(0, 0, 0, 0))
					local aQ = (aN and UDim2.new(1, 10, 0, 0) or UDim2.new(1, -aC.Width, 0, 0))

					ay.LeftToggle.Text = aM and ">" or "<"
					ay.RightToggle.Text = aN and "<" or ">"

					if not aL then
						local function insertTween(...)
							local aR = al.TweenService:Create(...)
							aG[#aG + 1] = aR
							aR:Play()
						end
						insertTween(aB.Frame, aF, { Position = aO })
						insertTween(aC.Frame, aF, { Position = aQ })
						insertTween(ay.LeftToggle, aF, { Position = UDim2.new(0, #aB.Windows == 0 and -16 or 0, 0, -36) })
						insertTween(ay.RightToggle, aF, { Position = UDim2.new(1, #aC.Windows == 0 and 0 or -16, 0, -36) })
					else
						aB.Frame.Position = aO
						aC.Frame.Position = aQ
						ay.LeftToggle.Position = UDim2.new(0, #aB.Windows == 0 and -16 or 0, 0, -36)
						ay.RightToggle.Position = UDim2.new(1, #aC.Windows == 0 and 0 or -16, 0, -36)
					end
				end

				local function getSideFramePos(aL)
					local aM = #aB.Windows == 0 or aB.Hidden
					local aN = #aC.Windows == 0 or aC.Hidden
					if aL == aB then
						return (aM and UDim2.new(0, -aB.Width - 10, 0, 0) or UDim2.new(0, 0, 0, 0))
					else
						return (aN and UDim2.new(1, 10, 0, 0) or UDim2.new(1, -aC.Width, 0, 0))
					end
				end

				local function sideResized(aL)
					local aM = 0
					local aN = getSideFramePos(aL)
					for aO, aQ in pairs(aL.Windows) do
						aQ.SizeX = aL.Width
						aQ.GuiElems.Main.Size = UDim2.new(0, aL.Width, 0, aQ.SizeY)
						aQ.GuiElems.Main.Position = UDim2.new(aN.X.Scale, aN.X.Offset, 0, aM)
						aM = aM + aQ.SizeY + 4
					end
				end

				local function sideResizerHook(aL, aM, aN, aO)
					local aQ = aa.Mouse
					local aR = aN.Windows

					aL.InputBegan:Connect(function(l)
						if not aN.Resizing then
							if l.UserInputType == Enum.UserInputType.MouseMovement then
								aL.BackgroundColor3 = aI.MainColor2
							elseif l.UserInputType == Enum.UserInputType.MouseButton1 then
								local m, n

								local o = aQ.X - aL.AbsolutePosition.X
								local p = aQ.Y - aL.AbsolutePosition.Y

								aN.Resizing = aL
								aL.BackgroundColor3 = aI.MainColor2

								m = al.UserInputService.InputEnded:Connect(function(q)
									if q.UserInputType == Enum.UserInputType.MouseButton1 then
										m:Disconnect()
										n:Disconnect()
										aN.Resizing = false
										aL.BackgroundColor3 = aI.Button
									end
								end)

								n = al.UserInputService.InputChanged:Connect(function(q)
									if not aL.Parent then
										m:Disconnect()
										n:Disconnect()
										aN.Resizing = false
										return
									end
									if q.UserInputType == Enum.UserInputType.MouseMovement then
										if aM == "V" then
											local r = q.Position.Y - aL.AbsolutePosition.Y - p

											if r > 0 then
												local s = r
												for t = aO + 1, #aR do
													local u = aR[t]
													local v = math.max(u.SizeY - s, (u.MinY or 100))
													s = s - (u.SizeY - v)
													u.SizeY = v
												end
												aR[aO].SizeY = aR[aO].SizeY + math.max(0, r - s)
											else
												local s = -r
												for t = aO, 1, -1 do
													local u = aR[t]
													local v = math.max(u.SizeY - s, (u.MinY or 100))
													s = s - (u.SizeY - v)
													u.SizeY = v
												end
												aR[aO + 1].SizeY = aR[aO + 1].SizeY + math.max(0, -r - s)
											end

											updateSideFrames()
											sideResized(aN)
										elseif aM == "H" then
											local r = math.max(300, ay.AbsoluteSize.X - aw.FreeWidth)
											local s = (aN == aB and aC or aB)
											local t = q.Position.X - aL.AbsolutePosition.X - o
											t = (aN == aB and t or -t)

											local u = math.max(aw.MinWidth, aN.Width + t)
											if u + s.Width <= r then
												aN.Width = u
											else
												local v = r - u
												if v >= aw.MinWidth then
													aN.Width = u
													s.Width = v
												else
													aN.Width = r - aw.MinWidth
													s.Width = aw.MinWidth
												end
											end

											updateSideFrames(true)
											sideResized(aN)
											sideResized(s)
										end
									end
								end)
							end
						end
					end)

					aL.InputEnded:Connect(function(l)
						if l.UserInputType == Enum.UserInputType.MouseMovement and aN.Resizing ~= aL then
							aL.BackgroundColor3 = aI.Button
						end
					end)
				end

				local function renderSide(aL, aM)
					local aN = 0
					local aO = getSideFramePos(aL)
					local aQ = aL.WindowResizer:Clone()
					for aR, l in pairs(aL.ResizeCons) do
						l:Disconnect()
					end
					for aR, l in pairs(aL.Frame:GetChildren()) do
						if l.Name == "WindowResizer" then
							l:Destroy()
						end
					end
					aL.ResizeCons = {}
					aL.Resizing = nil

					for aR, l in pairs(aL.Windows) do
						l.SidePos = aR
						local m = aR == #aL.Windows
						local n = UDim2.new(0, aL.Width, 0, l.SizeY)
						local o = UDim2.new(aO.X.Scale, aO.X.Offset, 0, aN)
						ap.ShowGui(l.Gui)

						if aM then
							l.GuiElems.Main.Size = n
							l.GuiElems.Main.Position = o
						else
							local p = al.TweenService:Create(l.GuiElems.Main, aF, { Size = n, Position = o })
							aG[#aG + 1] = p
							p:Play()
						end
						aN = aN + l.SizeY + 4

						if not m then
							local p = aQ:Clone()
							p.Position = UDim2.new(1, -aL.Width, 0, aN - 4)
							aL.ResizeCons[#aL.ResizeCons + 1] = l.Gui.Main:GetPropertyChangedSignal("Size"):Connect(function()
								p.Position = UDim2.new(1, -aL.Width, 0, l.GuiElems.Main.Position.Y.Offset + l.GuiElems.Main.Size.Y.Offset)
							end)
							aL.ResizeCons[#aL.ResizeCons + 1] = l.Gui.Main:GetPropertyChangedSignal("Position"):Connect(function()
								p.Position = UDim2.new(1, -aL.Width, 0, l.GuiElems.Main.Position.Y.Offset + l.GuiElems.Main.Size.Y.Offset)
							end)
							sideResizerHook(p, "V", aL, aR)
							p.Parent = aL.Frame
						end
					end
				end

				local function updateSide(aL, aM)
					local aN = 0
					local aO = 0
					local aQ = 0
					local aR = aL.Windows
					local l = ay.AbsoluteSize.Y - (math.max(0, #aR - 1) * 4)

					for m, n in pairs(aR) do
						aN = aN + n.SizeY
					end
					for m, n in pairs(aR) do
						if m == #aR then
							n.SizeY = l - aO
							aQ = math.max(0, (n.MinY or 100) - n.SizeY)
						else
							n.SizeY = math.max(math.floor(n.SizeY / aN * l), n.MinY or 100)
						end
						aO = aO + n.SizeY
					end

					if aQ > 0 then
						for m = #aR - 1, 1, -1 do
							local n = aR[m]
							local o = math.max(n.SizeY - aQ, (n.MinY or 100))
							aQ = aQ - (n.SizeY - o)
							n.SizeY = o
						end
						local m = aR[#aR]
						m.SizeY = (m.MinY or 100) - aQ
					end
					renderSide(aL, aM)
				end

				aJ = function(aL)
					updateSideFrames(aL)
					updateSide(aB, aL)
					updateSide(aC, aL)
					local aM = 0
					for aN = #aA, 1, -1 do
						aA[aN].Gui.DisplayOrder = aD + aM
						ap.ShowGui(aA[aN].Gui)
						aM = aM + 1
					end
				end

				av.SetMinimized = function(aL, aM, aN)
					local aO = aL.Minimized
					local aQ
					if aM == nil then
						aQ = not aL.Minimized
					else
						aQ = aM
					end
					aL.Minimized = aQ
					if not aN then
						aN = 1
					end

					local aR = aL.GuiElems.ResizeControls
					local l = { "North", "NorthEast", "NorthWest", "South", "SouthEast", "SouthWest" }
					for m = 1, #l do
						local n = aR:FindFirstChild(l[m])
						if n then
							n.Visible = not aQ
						end
					end

					if aN == 1 or aN == 2 then
						aL:StopTweens()
						if aN == 1 then
							aL.GuiElems.Main:TweenSize(UDim2.new(0, aL.SizeX, 0, aQ and 20 or aL.SizeY), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
						else
							local m = ay.AbsoluteSize.Y
							local n = UDim2.new(0, aL.PosX, 0, aQ and math.min(m - 20, aL.PosY + aL.SizeY - 20) or math.max(0, aL.PosY - aL.SizeY + 20))

							aL.GuiElems.Main:TweenPosition(n, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
							aL.GuiElems.Main:TweenSize(UDim2.new(0, aL.SizeX, 0, aQ and 20 or aL.SizeY), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
						end
						aL.GuiElems.Minimize.ImageLabel.Image = aQ and "rbxassetid://126656668566965" or "rbxassetid://93909547913779"
					end

					if aO ~= aQ then
						if aQ then
							aL.OnMinimize:Fire()
						else
							aL.OnRestore:Fire()
						end
					end
				end

				av.Resize = function(aL, aM, aN)
					aL.SizeX = aM or aL.SizeX
					aL.SizeY = aN or aL.SizeY
					aL.GuiElems.Main.Size = UDim2.new(0, aL.SizeX, 0, aL.SizeY)
				end

				av.SetSize = av.Resize

				av.SetTitle = function(aL, aM)
					aL.GuiElems.Title.Text = aM
				end

				av.SetResizable = function(aL, aM)
					aL.Resizable = aM
					aL.GuiElems.ResizeControls.Visible = aL.Resizable and aL.ResizableInternal
				end

				av.SetResizableInternal = function(aL, aM)
					aL.ResizableInternal = aM
					aL.GuiElems.ResizeControls.Visible = aL.Resizable and aL.ResizableInternal
				end

				av.SetAligned = function(aL, aM)
					aL.Aligned = aM
					aL:SetResizableInternal(not aM)
					aL.GuiElems.Main.Active = not aM
					aL.GuiElems.Main.Outlines.Visible = not aM
					if not aM then
						for aN, aO in pairs(aB.Windows) do
							if aO == aL then
								table.remove(aB.Windows, aN)
								break
							end
						end
						for aN, aO in pairs(aC.Windows) do
							if aO == aL then
								table.remove(aC.Windows, aN)
								break
							end
						end
						if not table.find(aA, aL) then
							table.insert(aA, 1, aL)
						end
						aL.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://93909547913779"
						aL.Side = nil
						aJ()
					else
						aL:SetMinimized(false, 3)
						for aN, aO in pairs(aA) do
							if aO == aL then
								table.remove(aA, aN)
								break
							end
						end
						aL.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://77696835026861"
					end
				end

				av.Add = function(aL, aM, aN)
					if type(aM) == "table" and aM.Gui and aM.Gui:IsA("GuiObject") then
						aM.Gui.Parent = aL.ContentPane
					else
						aM.Parent = aL.ContentPane
					end
					if aN then
						aL.Elements[aN] = aM
					end
				end

				av.GetElement = function(aL, aM, aN)
					return aL.Elements[aN]
				end

				av.AlignTo = function(aL, aM, aN, aO, aQ)
					if table.find(aM.Windows, aL) or aL.Closed then
						return
					end

					aO = aO or aL.SizeY
					if aO > 0 and aO <= 1 then
						local aR = 0
						for l, m in pairs(aM.Windows) do
							aR = aR + m.SizeY
						end
						aL.SizeY = (aR > 0 and aR * aO * 2) or aO
					else
						aL.SizeY = (aO > 0 and aO or 100)
					end

					aL:SetAligned(true)
					aL.Side = aM
					aL.SizeX = aM.Width
					aL.Gui.DisplayOrder = aE + 1
					for aR, l in pairs(aM.Windows) do
						l.Gui.DisplayOrder = aE
					end
					aN = math.min(#aM.Windows + 1, aN or 1)
					aL.SidePos = aN
					table.insert(aM.Windows, aN, aL)

					if not aQ then
						aM.Hidden = false
					end
				end

				av.Close = function(aL)
					aL.Closed = true
					aL:SetResizableInternal(false)

					ap.FindAndRemove(aB.Windows, aL)
					ap.FindAndRemove(aC.Windows, aL)
					ap.FindAndRemove(aA, aL)

					aL.MinimizeAnim.Disable()
					aL.CloseAnim.Disable()
					aL.ClosedSide = aL.Side
					aL.Side = nil
					aL.OnDeactivate:Fire()

					if not aL.Aligned then
						aL:StopTweens()
						local aM = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						local aN = tick()
						aL.LastClose = aN

						aL:DoTween(aL.GuiElems.Main, aM, { Size = UDim2.new(0, aL.SizeX, 0, 20) })
						aL:DoTween(aL.GuiElems.Title, aM, { TextTransparency = 1 })
						aL:DoTween(aL.GuiElems.Minimize.ImageLabel, aM, { ImageTransparency = 1 })
						aL:DoTween(aL.GuiElems.Close.ImageLabel, aM, { ImageTransparency = 1 })
						ap.FastWait(0.2)
						if aN ~= aL.LastClose then
							return
						end

						aL:DoTween(aL.GuiElems.TopBar, aM, { BackgroundTransparency = 1 })
						aL:DoTween(aL.GuiElems.Outlines, aM, { ImageTransparency = 1 })
						ap.FastWait(0.2)
						if aN ~= aL.LastClose then
							return
						end
					end

					aL.Aligned = false
					aL.Gui.Parent = nil
					aJ(true)
				end

				av.Hide = av.Close

				av.IsVisible = function(aL)
					return not aL.Closed and ((aL.Side and not aL.Side.Hidden) or not aL.Side)
				end

				av.IsContentVisible = function(aL)
					return aL:IsVisible() and not aL.Minimized
				end

				av.Focus = function(aL)
					moveToTop(aL)
				end

				av.MoveInBoundary = function(aL)
					local aM, aN = aL.PosX, aL.PosY
					local aO, aQ = ay.AbsoluteSize.X, ay.AbsoluteSize.Y
					aM = math.min(aM, aO - aL.SizeX)
					aN = math.min(aN, aQ - 20)
					aL.GuiElems.Main.Position = UDim2.new(0, aM, 0, aN)
				end

				av.DoTween = function(aL, ...)
					local aM = al.TweenService:Create(...)
					aL.Tweens[#aL.Tweens + 1] = aM
					aM:Play()
				end

				av.StopTweens = function(aL)
					for aM, aN in pairs(aL.Tweens) do
						aN:Cancel()
					end
					aL.Tweens = {}
				end

				av.Show = function(aL, aM)
					return aw.ShowWindow(aL, aM)
				end

				av.ShowAndFocus = function(aL, aM)
					aw.ShowWindow(aL, aM)
					al.RunService.RenderStepped:wait()
					aL:Focus()
				end

				aw.ShowWindow = function(aL, aM)
					aM = aM or {}
					local aN = aM.Align
					local aO = aM.Pos
					local aQ = aM.Size
					local aR = (aN == "left" and aB) or (aN == "right" and aC)

					if not aL.Closed then
						if not aL.Aligned then
							aL:SetMinimized(false)
						elseif aL.Side and not aM.Silent then
							aw.SetSideVisible(aL.Side, true)
						end
						return
					end

					aL.Closed = false
					aL.LastClose = tick()
					aL.GuiElems.Title.TextTransparency = 0
					aL.GuiElems.Minimize.ImageLabel.ImageTransparency = 0
					aL.GuiElems.Close.ImageLabel.ImageTransparency = 0
					aL.GuiElems.TopBar.BackgroundTransparency = 0
					aL.GuiElems.Outlines.ImageTransparency = 0
					aL.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://93909547913779"
					aL.GuiElems.Main.Active = true
					aL.GuiElems.Main.Outlines.Visible = true
					aL:SetMinimized(false, 3)
					aL:SetResizableInternal(true)
					aL.MinimizeAnim.Enable()
					aL.CloseAnim.Enable()

					if aN then
						aL:AlignTo(aR, aO, aQ, aM.Silent)
					else
						if aN == nil and aL.ClosedSide then
							aL:AlignTo(aL.ClosedSide, aL.SidePos, aQ, true)
							aw.SetSideVisible(aL.ClosedSide, true)
						else
							if table.find(aA, aL) then
								return
							end

							aL.GuiElems.Main.Size = UDim2.new(0, aL.SizeX, 0, 20)
							local l = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							aL:StopTweens()
							aL:DoTween(aL.GuiElems.Main, l, { Size = UDim2.new(0, aL.SizeX, 0, aL.SizeY) })

							aL.SizeY = aQ or aL.SizeY
							table.insert(aA, 1, aL)
							aJ()
						end
					end

					aL.ClosedSide = nil
					aL.OnActivate:Fire()
				end

				aw.ToggleSide = function(aL)
					local aM = (aL == "left" and aB or aC)
					aM.Hidden = not aM.Hidden
					for aN, aO in pairs(aM.Windows) do
						if aM.Hidden then
							aO.OnDeactivate:Fire()
						else
							aO.OnActivate:Fire()
						end
					end
					aJ()
				end

				aw.SetSideVisible = function(aL, aM)
					local aN = (type(aL) == "table" and aL) or (aL == "left" and aB or aC)
					aN.Hidden = not aM
					for aO, aQ in pairs(aN.Windows) do
						if aN.Hidden then
							aQ.OnDeactivate:Fire()
						else
							aQ.OnActivate:Fire()
						end
					end
					aJ()
				end

				aw.Init = function()
					aD = aa.DisplayOrders.Window
					aE = aa.DisplayOrders.SideWindow

					ay = Instance.new("ScreenGui")
					local aL = an({
						{ 1, "Frame", { Active = true, Name = "LeftSide", BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0 } },
						{ 2, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933), BorderSizePixel = 0, Font = 3, Name = "Resizer", Parent = { 1 }, Size = UDim2.new(0, 5, 1, 0), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 3, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderSizePixel = 0, Name = "Line", Parent = { 2 }, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0) } },
						{ 4, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933), BorderSizePixel = 0, Font = 3, Name = "WindowResizer", Parent = { 1 }, Position = UDim2.new(1, -300, 0, 0), Size = UDim2.new(1, 0, 0, 4), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 5, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderSizePixel = 0, Name = "Line", Parent = { 4 }, Size = UDim2.new(1, 0, 0, 1) } },
					})
					aB.Frame = aL
					aL.Position = UDim2.new(0, -aB.Width - 10, 0, 0)
					aB.WindowResizer = aL.WindowResizer
					aL.WindowResizer.Parent = nil
					aL.Parent = ay

					local aM = an({
						{ 1, "Frame", { Active = true, Name = "RightSide", BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0 } },
						{ 2, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933), BorderSizePixel = 0, Font = 3, Name = "Resizer", Parent = { 1 }, Size = UDim2.new(0, 5, 1, 0), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 3, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderSizePixel = 0, Name = "Line", Parent = { 2 }, Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(0, 1, 1, 0) } },
						{ 4, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933), BorderSizePixel = 0, Font = 3, Name = "WindowResizer", Parent = { 1 }, Position = UDim2.new(1, -300, 0, 0), Size = UDim2.new(1, 0, 0, 4), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
						{ 5, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderSizePixel = 0, Name = "Line", Parent = { 4 }, Size = UDim2.new(1, 0, 0, 1) } },
					})
					aC.Frame = aM
					aM.Position = UDim2.new(1, 10, 0, 0)
					aC.WindowResizer = aM.WindowResizer
					aM.WindowResizer.Parent = nil
					aM.Parent = ay

					sideResizerHook(aL.Resizer, "H", aB)
					sideResizerHook(aM.Resizer, "H", aC)

					az = Instance.new("ScreenGui")
					az.DisplayOrder = aa.DisplayOrders.Core
					local aN = Instance.new("Frame", az)
					aN.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
					aN.BorderSizePixel = 0
					aN.BackgroundTransparency = 0.8
					aN.Name = "Indicator"
					local aO = Instance.new("UICorner", aN)
					aO.CornerRadius = UDim.new(0, 10)

					local aQ = an({ { 1, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderMode = 2, Font = 10, Name = "LeftToggle", Position = UDim2.new(0, 0, 0, -36), Size = UDim2.new(0, 16, 0, 36), Text = "<", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } } })
					local aR = aQ:Clone()
					aR.Name = "RightToggle"
					aR.Position = UDim2.new(1, -16, 0, -36)
					ap.ButtonAnim(aQ, { Mode = 2, PressColor = Color3.fromRGB(32, 32, 32) })
					ap.ButtonAnim(aR, { Mode = 2, PressColor = Color3.fromRGB(32, 32, 32) })

					aQ.MouseButton1Click:Connect(function()
						aw.ToggleSide("left")
					end)

					aR.MouseButton1Click:Connect(function()
						aw.ToggleSide("right")
					end)

					aQ.Parent = ay
					aR.Parent = ay

					ay:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						local l = math.max(300, ay.AbsoluteSize.X - aw.FreeWidth)
						aB.Width = math.max(aw.MinWidth, math.min(aB.Width, l - aC.Width))
						aC.Width = math.max(aw.MinWidth, math.min(aC.Width, l - aB.Width))
						for m = 1, #aA do
							aA[m]:MoveInBoundary()
						end
						aJ(true)
					end)

					ay.DisplayOrder = aE - 1
					ap.ShowGui(ay)
					updateSideFrames()
				end

				local aL = { __index = av }
				aw.new = function()
					local aM = setmetatable({
						Minimized = false,
						Dragging = false,
						Resizing = false,
						Aligned = false,
						Draggable = true,
						Resizable = true,
						ResizableInternal = true,
						Alignable = true,
						Closed = true,
						SizeX = 300,
						SizeY = 300,
						MinX = 200,
						MinY = 200,
						PosX = 0,
						PosY = 0,
						GuiElems = {},
						Tweens = {},
						Elements = {},
						OnActivate = ap.Signal.new(),
						OnDeactivate = ap.Signal.new(),
						OnMinimize = ap.Signal.new(),
						OnRestore = ap.Signal.new(),
					}, aL)
					aM.Gui = aK(aM)
					return aM
				end

				return aw
			end)()

			ap.ContextMenu = (function()
				local av = {}
				local aw

				local function createGui(ax)
					local ay = an({
						{ 1, "ScreenGui", { DisplayOrder = 1000000, Name = "Context", ZIndexBehavior = 1 } },
						{ 2, "Frame", { Active = true, BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), Name = "Main", Parent = { 1 }, Position = UDim2.new(0.5, -100, 0.5, -150), Size = UDim2.new(0, 200, 0, 100) } },
						{ 3, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 2 } } },
						{ 4, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), Name = "Container", Parent = { 2 }, Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2) } },
						{ 5, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 4 } } },
						{ 6, "ScrollingFrame", { Active = true, BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), Name = "List", Parent = { 4 }, Position = UDim2.new(0, 2, 0, 2), ScrollBarImageColor3 = Color3.new(0, 0, 0), ScrollBarThickness = 4, Size = UDim2.new(1, -4, 1, -4), VerticalScrollBarInset = 1 } },
						{ 7, "UIListLayout", { Parent = { 6 }, SortOrder = 2 } },
						{ 8, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "SearchFrame", Parent = { 4 }, Size = UDim2.new(1, 0, 0, 24), Visible = false } },
						{ 9, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.1176470592618, 0.1176470592618, 0.1176470592618), BorderSizePixel = 0, Name = "SearchContainer", Parent = { 8 }, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(1, -6, 0, 18) } },
						{ 10, "TextBox", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "SearchBox", Parent = { 9 }, PlaceholderColor3 = Color3.new(0.39215689897537, 0.39215689897537, 0.39215689897537), PlaceholderText = "Search", Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -8, 0, 18), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 0 } },
						{ 11, "UICorner", { CornerRadius = UDim.new(0, 2), Parent = { 9 } } },
						{ 12, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderSizePixel = 0, Name = "Line", Parent = { 8 }, Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1) } },
						{ 13, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.33725491166115, 0.49019610881805, 0.73725491762161), BorderSizePixel = 0, Font = 3, Name = "Entry", Parent = { 1 }, Size = UDim2.new(1, 0, 0, 22), Text = "", TextSize = 14, Visible = false } },
						{ 14, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "EntryName", Parent = { 13 }, Position = UDim2.new(0, 24, 0, 0), Size = UDim2.new(1, -24, 1, 0), Text = "Duplicate", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 15, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Shortcut", Parent = { 13 }, Position = UDim2.new(0, 24, 0, 0), Size = UDim2.new(1, -30, 1, 0), Text = "Ctrl+D", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 16, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ImageRectOffset = Vector2.new(304, 0), ImageRectSize = Vector2.new(16, 16), Name = "Icon", Parent = { 13 }, Position = UDim2.new(0, 2, 0, 3), ScaleType = 4, Size = UDim2.new(0, 16, 0, 16) } },
						{ 17, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 13 } } },
						{ 18, "Frame", { BackgroundColor3 = Color3.new(0.21568629145622, 0.21568629145622, 0.21568629145622), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Divider", Parent = { 1 }, Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 7), Visible = false } },
						{ 19, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "Line", Parent = { 18 }, Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 1) } },
						{ 20, "TextLabel", { AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "DividerName", Parent = { 18 }, Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.new(1, -4, 1, 0), Text = "Objects", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 0.60000002384186, TextXAlignment = 0, Visible = false } },
					})
					ax.GuiElems.Main = ay.Main
					ax.GuiElems.List = ay.Main.Container.List
					ax.GuiElems.Entry = ay.Entry
					ax.GuiElems.Divider = ay.Divider
					ax.GuiElems.SearchFrame = ay.Main.Container.SearchFrame
					ax.GuiElems.SearchBar = ax.GuiElems.SearchFrame.SearchContainer.SearchBox
					ap.ViewportTextBox.convert(ax.GuiElems.SearchBar)

					ax.GuiElems.SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
						local az, aA = string.lower, string.find
						local aB = az(ax.GuiElems.SearchBar.Text)
						local aC = ax.Items
						local aD = ax.ItemToEntryMap

						if aB ~= "" then
							local aE = {}
							local aF = 1
							for aG = 1, #aC do
								local aH = aC[aG]
								local aI = aD[aH]
								if aI then
									if not aH.Divider and aA(az(aH.Name), aB, 1, true) then
										aE[aF] = aH
										aF = aF + 1
									else
										aI.Visible = false
									end
								end
							end
							table.sort(aE, function(aG, aH)
								return aG.Name < aH.Name
							end)
							for aG = 1, #aE do
								local aH = aD[aE[aG]]
								aH.LayoutOrder = aG
								aH.Visible = true
							end
						else
							for aE = 1, #aC do
								local aF = aD[aC[aE]]
								if aF then
									aF.LayoutOrder = aE
									aF.Visible = true
								end
							end
						end

						local aE = ax.GuiElems.List.UIListLayout.AbsoluteContentSize.Y + 6
						ax.GuiElems.List.CanvasSize = UDim2.new(0, 0, 0, aE - 6)
					end)

					return ay
				end

				av.Add = function(ax, ay)
					local az = {
						Name = ay.Name or "Item",
						Icon = ay.Icon or "",
						Shortcut = ay.Shortcut or "",
						OnClick = ay.OnClick,
						OnHover = ay.OnHover,
						Disabled = ay.Disabled or false,
						DisabledIcon = ay.DisabledIcon or "",
						IconMap = ay.IconMap,
						OnRightClick = ay.OnRightClick,
					}
					if ax.QueuedDivider then
						local aA = ax.QueuedDividerText and #ax.QueuedDividerText > 0 and ax.QueuedDividerText
						ax:AddDivider(aA)
					end
					ax.Items[#ax.Items + 1] = az
					ax.Updated = nil
				end

				av.AddRegistered = function(ax, ay, az)
					if not ax.Registered[ay] then
						error(ay .. " is not registered")
					end

					if ax.QueuedDivider then
						local aA = ax.QueuedDividerText and #ax.QueuedDividerText > 0 and ax.QueuedDividerText
						ax:AddDivider(aA)
					end
					ax.Registered[ay].Disabled = az
					ax.Items[#ax.Items + 1] = ax.Registered[ay]
					ax.Updated = nil
				end

				av.Register = function(ax, ay, az)
					ax.Registered[ay] = {
						Name = az.Name or "Item",
						Icon = az.Icon or "",
						Shortcut = az.Shortcut or "",
						OnClick = az.OnClick,
						OnHover = az.OnHover,
						DisabledIcon = az.DisabledIcon or "",
						IconMap = az.IconMap,
						OnRightClick = az.OnRightClick,
					}
				end

				av.UnRegister = function(ax, ay)
					ax.Registered[ay] = nil
				end

				av.AddDivider = function(ax, ay)
					ax.QueuedDivider = false
					local az = ay and al.TextService:GetTextSize(ay, 14, Enum.Font.SourceSans, Vector2.new(999999999, 20)).X or nil
					table.insert(ax.Items, { Divider = true, Text = ay, TextSize = az and az + 4 })
					ax.Updated = nil
				end

				av.QueueDivider = function(ax, ay)
					ax.QueuedDivider = true
					ax.QueuedDividerText = ay or ""
				end

				av.Clear = function(ax)
					ax.Items = {}
					ax.Updated = nil
				end

				av.Refresh = function(ax)
					for ay, az in pairs(ax.GuiElems.List:GetChildren()) do
						if not az:IsA("UIListLayout") then
							az:Destroy()
						end
					end
					local ay = {}
					ax.ItemToEntryMap = ay

					local az = ax.GuiElems.Divider
					local aA = ax.GuiElems.List
					local aB = ax.GuiElems.Entry
					local aC = ax.Items

					for aD = 1, #aC do
						local aE = aC[aD]
						if aE.Divider then
							local aF = az:Clone()
							aF.Line.BackgroundColor3 = ax.Theme.DividerColor
							if aE.Text then
								aF.Size = UDim2.new(1, 0, 0, 20)
								aF.Line.Position = UDim2.new(0, aE.TextSize, 0.5, 0)
								aF.Line.Size = UDim2.new(1, -aE.TextSize, 0, 1)
								aF.DividerName.TextColor3 = ax.Theme.TextColor
								aF.DividerName.Text = aE.Text
								aF.DividerName.Visible = true
							end
							aF.Visible = true
							ay[aE] = aF
							aF.Parent = aA
						else
							local aF = aB:Clone()
							aF.BackgroundColor3 = ax.Theme.HighlightColor
							aF.EntryName.TextColor3 = ax.Theme.TextColor
							aF.EntryName.Text = aE.Name
							aF.Shortcut.Text = aE.Shortcut
							if aE.Disabled then
								aF.EntryName.TextColor3 = Color3.new(0.5882352941176471, 0.5882352941176471, 0.5882352941176471)
								aF.Shortcut.TextColor3 = Color3.new(0.5882352941176471, 0.5882352941176471, 0.5882352941176471)
							end

							if ax.Iconless then
								aF.EntryName.Position = UDim2.new(0, 2, 0, 0)
								aF.EntryName.Size = UDim2.new(1, -4, 0, 20)
								aF.Icon.Visible = false
							else
								local aG = aE.Disabled and aE.DisabledIcon or aE.Icon
								if aE.IconMap then
									if type(aG) == "number" then
										aE.IconMap:Display(aF.Icon, aG)
									elseif type(aG) == "string" then
										aE.IconMap:DisplayByKey(aF.Icon, aG)
									end
								elseif type(aG) == "string" then
									aF.Icon.Image = aG
								end
							end

							if not aE.Disabled then
								if aE.OnClick then
									aF.MouseButton1Click:Connect(function()
										aE.OnClick(aE.Name)
										if not aE.NoHide then
											ax:Hide()
										end
									end)
								end

								if aE.OnRightClick then
									aF.MouseButton2Click:Connect(function()
										aE.OnRightClick(aE.Name)
										if not aE.NoHide then
											ax:Hide()
										end
									end)
								end
							end

							aF.InputBegan:Connect(function(aG)
								if aG.UserInputType == Enum.UserInputType.MouseMovement then
									aF.BackgroundTransparency = 0
								end
							end)

							aF.InputEnded:Connect(function(aG)
								if aG.UserInputType == Enum.UserInputType.MouseMovement then
									aF.BackgroundTransparency = 1
								end
							end)

							aF.Visible = true
							ay[aE] = aF
							aF.Parent = aA
						end
					end
					ax.Updated = true
				end

				av.Show = function(ax, ay, az)
					local aA = ax.GuiElems
					aA.SearchFrame.Visible = ax.SearchEnabled
					aA.List.Position = UDim2.new(0, 2, 0, 2 + (ax.SearchEnabled and 24 or 0))
					aA.List.Size = UDim2.new(1, -4, 1, -4 - (ax.SearchEnabled and 24 or 0))
					if ax.SearchEnabled and ax.ClearSearchOnShow then
						aA.SearchBar.Text = ""
					end
					ax.GuiElems.List.CanvasPosition = Vector2.new(0, 0)

					if not ax.Updated then
						ax:Refresh()
					end

					local aB = false
					local aC, aD = ay or aw.X, az or aw.Y
					local aE, aF = aw.ViewSizeX, aw.ViewSizeY

					if aC + ax.Width > aE then
						aC = ax.ReverseX and aC - ax.Width or aE - ax.Width
					end
					aA.Main.Position = UDim2.new(0, aC, 0, aD)
					aA.Main.Size = UDim2.new(0, ax.Width, 0, 0)
					ax.Gui.DisplayOrder = aa.DisplayOrders.Menu
					ap.ShowGui(ax.Gui)

					local aG = aA.List.UIListLayout.AbsoluteContentSize.Y + 6
					if ax.MaxHeight and aG > ax.MaxHeight then
						aA.List.CanvasSize = UDim2.new(0, 0, 0, aG - 6)
						aG = ax.MaxHeight
					else
						aA.List.CanvasSize = UDim2.new(0, 0, 0, 0)
					end
					if aD + aG > aF then
						aB = true
					end

					local aH
					if ax.CloseEvent then
						ax.CloseEvent:Disconnect()
					end
					ax.CloseEvent = al.UserInputService.InputBegan:Connect(function(aI)
						if not aH or aI.UserInputType ~= Enum.UserInputType.MouseButton1 then
							return
						end

						if not ap.CheckMouseInGui(aA.Main) then
							ax.CloseEvent:Disconnect()
							ax:Hide()
						end
					end)

					if aB then
						aA.Main.Position = UDim2.new(0, aC, 0, aD - (ax.ReverseYOffset or 0))
						local aI = aD - aG - (ax.ReverseYOffset or 0)
						aD = aI >= 0 and aI or 0
						aA.Main:TweenSizeAndPosition(UDim2.new(0, ax.Width, 0, aG), UDim2.new(0, aC, 0, aD), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
					else
						aA.Main:TweenSize(UDim2.new(0, ax.Width, 0, aG), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
					end

					ap.FastWait()
					if ax.SearchEnabled and ax.FocusSearchOnShow then
						aA.SearchBar:CaptureFocus()
					end
					aH = true
				end

				av.Hide = function(ax)
					ax.Gui.Parent = nil
				end

				av.ApplyTheme = function(ax, ay)
					local az = ax.Theme
					az.ContentColor = ay.ContentColor or ad.Theme.Menu
					az.OutlineColor = ay.OutlineColor or ad.Theme.Menu
					az.DividerColor = ay.DividerColor or ad.Theme.Outline2
					az.TextColor = ay.TextColor or ad.Theme.Text
					az.HighlightColor = ay.HighlightColor or ad.Theme.Main1

					ax.GuiElems.Main.BackgroundColor3 = az.OutlineColor
					ax.GuiElems.Main.Container.BackgroundColor3 = az.ContentColor
				end

				local ax = { __index = av }
				local function new()
					if not aw then
						aw = aa.Mouse or al.Players.LocalPlayer:GetMouse()
					end

					local ay = setmetatable({
						Width = 200,
						MaxHeight = nil,
						Iconless = false,
						SearchEnabled = false,
						ClearSearchOnShow = true,
						FocusSearchOnShow = true,
						Updated = false,
						QueuedDivider = false,
						QueuedDividerText = "",
						Items = {},
						Registered = {},
						GuiElems = {},
						Theme = {},
					}, ax)
					ay.Gui = createGui(ay)
					ay:ApplyTheme({})
					return ay
				end

				return { new = new }
			end)()

			ap.CodeFrame = (function()
				local av = {}

				local aw = {
					[1] = "String",
					[2] = "String",
					[3] = "String",
					[4] = "Comment",
					[5] = "Operator",
					[6] = "Number",
					[7] = "Keyword",
					[8] = "BuiltIn",
					[9] = "LocalMethod",
					[10] = "LocalProperty",
					[11] = "Nil",
					[12] = "Bool",
					[13] = "Function",
					[14] = "Local",
					[15] = "Self",
					[16] = "FunctionName",
					[17] = "Bracket",
				}

				local ax = {
					["nil"] = 11,
					["true"] = 12,
					["false"] = 12,
					["function"] = 13,
					["local"] = 14,
					self = 15,
				}

				local ay = {
					["and"] = true,
					["break"] = true,
					["do"] = true,
					["else"] = true,
					["elseif"] = true,
					["end"] = true,
					["false"] = true,
					["for"] = true,
					["function"] = true,
					["if"] = true,
					["in"] = true,
					["local"] = true,
					["nil"] = true,
					["not"] = true,
					["or"] = true,
					["repeat"] = true,
					["return"] = true,
					["then"] = true,
					["true"] = true,
					["until"] = true,
					["while"] = true,
					plugin = true,
				}

				local az = {
					delay = true,
					elapsedTime = true,
					require = true,
					spawn = true,
					tick = true,
					time = true,
					typeof = true,
					UserSettings = true,
					wait = true,
					warn = true,
					game = true,
					shared = true,
					script = true,
					workspace = true,
					assert = true,
					collectgarbage = true,
					error = true,
					getfenv = true,
					getmetatable = true,
					ipairs = true,
					loadstring = true,
					newproxy = true,
					next = true,
					pairs = true,
					pcall = true,
					print = true,
					rawequal = true,
					rawget = true,
					rawset = true,
					select = true,
					setfenv = true,
					setmetatable = true,
					tonumber = true,
					tostring = true,
					type = true,
					unpack = true,
					xpcall = true,
					_G = true,
					_VERSION = true,
					coroutine = true,
					debug = true,
					math = true,
					os = true,
					string = true,
					table = true,
					bit32 = true,
					utf8 = true,
					Axes = true,
					BrickColor = true,
					CFrame = true,
					Color3 = true,
					ColorSequence = true,
					ColorSequenceKeypoint = true,
					DockWidgetPluginGuiInfo = true,
					Enum = true,
					Faces = true,
					Instance = true,
					NumberRange = true,
					NumberSequence = true,
					NumberSequenceKeypoint = true,
					PathWaypoint = true,
					PhysicalProperties = true,
					Random = true,
					Ray = true,
					Rect = true,
					Region3 = true,
					Region3int16 = true,
					TweenInfo = true,
					UDim = true,
					UDim2 = true,
					Vector2 = true,
					Vector2int16 = true,
					Vector3 = true,
					Vector3int16 = true,
				}

				local aA = false

				local aB = {
					["'"] = "&apos;",
					['"'] = "&quot;",
					["<"] = "&lt;",
					[">"] = "&gt;",
					["&"] = "&amp;",
				}

				local aC = "\205"
				local aD = (" %s%s "):format(aC, aC)

				local aE = {
					[("[^%s] %s"):format(aC, aC)] = 0,
					[(" %s%s"):format(aC, aC)] = -1,
					[("%s%s "):format(aC, aC)] = 2,
					[("%s [^%s]"):format(aC, aC)] = 1,
				}

				local aF = al.TweenService
				local aG = {}

				local function initBuiltIn()
					local aH = getfenv()
					local aI = type
					local aJ = tostring
					for aK, aL in next, az do
						local aM = aH[aK]
						if aI(aM) == "table" then
							local aN = {}
							for aO, aQ in next, aM do
								aN[aO] = true
							end
							az[aK] = aN
						end
					end

					local aK = {}
					local aL = Enum:GetEnums()
					for aM = 1, #aL do
						aK[aJ(aL[aM])] = true
					end
					az.Enum = aK

					aA = true
				end

				local function setupEditBox(aH)
					local aI = aH.GuiElems.EditBox

					aI.Focused:Connect(function()
						aH:ConnectEditBoxEvent()
						aH.Editing = true
					end)

					aI.FocusLost:Connect(function()
						aH:DisconnectEditBoxEvent()
						aH.Editing = false
					end)

					aI:GetPropertyChangedSignal("Text"):Connect(function()
						local aJ = aI.Text
						if #aJ == 0 or aH.EditBoxCopying then
							return
						end
						aI.Text = ""
						aH:AppendText(aJ)
					end)
				end

				local function setupMouseSelection(aH)
					local aI = am:GetMouse()
					local aJ = aH.GuiElems.LinesFrame
					local aK = aH.Lines

					aJ.InputBegan:Connect(function(aL)
						if aL.UserInputType == Enum.UserInputType.MouseButton1 then
							local aM, aN = math.ceil(aH.FontSize / 2), aH.FontSize

							local aO = aI.X - aJ.AbsolutePosition.X
							local aQ = aI.Y - aJ.AbsolutePosition.Y
							local aR = math.round(aO / aM) + aH.ViewX
							local l = math.floor(aQ / aN) + aH.ViewY
							local m, n, o
							local p, q = 0, 0
							l = math.min(#aK - 1, l)
							local r = aK[l + 1] or ""
							aR = math.min(#r, aR + aH:TabAdjust(aR, l))

							aH.SelectionRange = { { -1, -1 }, { -1, -1 } }
							aH:MoveCursor(aR, l)
							aH.FloatCursorX = aR

							local function updateSelection()
								local s = aI.X - aJ.AbsolutePosition.X
								local t = aI.Y - aJ.AbsolutePosition.Y
								local u = math.max(0, math.round(s / aM) + aH.ViewX)
								local v = math.max(0, math.floor(t / aN) + aH.ViewY)

								v = math.min(#aK - 1, v)
								local w = aK[v + 1] or ""
								u = math.min(#w, u + aH:TabAdjust(u, v))

								if v < l or (v == l and u < aR) then
									aH.SelectionRange = { { u, v }, { aR, l } }
								else
									aH.SelectionRange = { { aR, l }, { u, v } }
								end

								aH:MoveCursor(u, v)
								aH.FloatCursorX = u
								aH:Refresh()
							end

							m = al.UserInputService.InputEnded:Connect(function(s)
								if s.UserInputType == Enum.UserInputType.MouseButton1 then
									m:Disconnect()
									n:Disconnect()
									o:Disconnect()
									aH:SetCopyableSelection()
								end
							end)

							n = al.UserInputService.InputChanged:Connect(function(s)
								if s.UserInputType == Enum.UserInputType.MouseMovement then
									local t = aI.Y - aJ.AbsolutePosition.Y
									local u = aI.Y - aJ.AbsolutePosition.Y - aJ.AbsoluteSize.Y
									local v = aI.X - aJ.AbsolutePosition.X
									local w = aI.X - aJ.AbsolutePosition.X - aJ.AbsoluteSize.X
									p = 0
									q = 0
									if u > 0 then
										p = math.floor(u * 0.05) + 1
									elseif t < 0 then
										p = math.ceil(t * 0.05) - 1
									end
									if w > 0 then
										q = math.floor(w * 0.05) + 1
									elseif v < 0 then
										q = math.ceil(v * 0.05) - 1
									end
									updateSelection()
								end
							end)

							o = i(game:GetService("RunService")).RenderStepped:Connect(function()
								if p ~= 0 or q ~= 0 then
									aH:ScrollDelta(q, p)
									updateSelection()
								end
							end)

							aH:Refresh()
						end
					end)
				end

				local function makeFrame(aH)
					local aI = an({
						{ 1, "Frame", { BackgroundColor3 = Color3.new(0.15686275064945, 0.15686275064945, 0.15686275064945), BorderSizePixel = 0, Position = UDim2.new(0.5, -300, 0.5, -200), Size = UDim2.new(0, 600, 0, 400) } },
					})
					local aJ = {}

					local aK = Instance.new("Frame")
					aK.Name = "Lines"
					aK.BackgroundTransparency = 1
					aK.Size = UDim2.new(1, 0, 1, 0)
					aK.ClipsDescendants = true
					aK.Parent = aI

					local aL = Instance.new("TextLabel")
					aL.Name = "LineNumbers"
					aL.BackgroundTransparency = 1
					aL.Font = Enum.Font.Code
					aL.TextXAlignment = Enum.TextXAlignment.Right
					aL.TextYAlignment = Enum.TextYAlignment.Top
					aL.ClipsDescendants = true
					aL.RichText = true
					aL.Parent = aI

					local aM = Instance.new("Frame")
					aM.Name = "Cursor"
					aM.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
					aM.BorderSizePixel = 0
					aM.Parent = aI

					local aN = Instance.new("TextBox")
					aN.Name = "EditBox"
					aN.MultiLine = true
					aN.Visible = false
					aN.Parent = aI

					aG.Invis = aF:Create(aM, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
					aG.Vis = aF:Create(aM, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 })

					aJ.LinesFrame = aK
					aJ.LineNumbersLabel = aL
					aJ.Cursor = aM
					aJ.EditBox = aN
					aJ.ScrollCorner = an({ { 1, "Frame", { BackgroundColor3 = Color3.new(0.15686275064945, 0.15686275064945, 0.15686275064945), BorderSizePixel = 0, Name = "ScrollCorner", Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, 16, 0, 16), Visible = false } } })

					aJ.ScrollCorner.Parent = aI
					aK.InputBegan:Connect(function(aO)
						if aO.UserInputType == Enum.UserInputType.MouseButton1 then
							aH:SetEditing(true, aO)
						end
					end)

					aH.Frame = aI
					aH.Gui = aI
					aH.GuiElems = aJ
					setupEditBox(aH)
					setupMouseSelection(aH)

					return aI
				end

				av.GetSelectionText = function(aH)
					if not aH:IsValidRange() then
						return ""
					end

					local aI = aH.SelectionRange
					local aJ, aK = aI[1][1], aI[1][2]
					local aL, aM = aI[2][1], aI[2][2]
					local aN = aM - aK
					local aO = aH.Lines

					if not aO[aK + 1] or not aO[aM + 1] then
						return ""
					end

					if aN == 0 then
						return aH:ConvertText(aO[aK + 1]:sub(aJ + 1, aL), false)
					end

					local aQ = aO[aK + 1]:sub(aJ + 1)
					local aR = aO[aM + 1]:sub(1, aL)

					local l = aQ .. "\n"
					for m = aK + 1, aM - 1 do
						l = l .. aO[m + 1] .. "\n"
					end
					l = l .. aR

					return aH:ConvertText(l, false)
				end

				av.SetCopyableSelection = function(aH)
					local aI = aH:GetSelectionText()
					local aJ = aH.GuiElems.EditBox

					aH.EditBoxCopying = true
					aJ.Text = aI
					aJ.SelectionStart = 1
					aJ.CursorPosition = #aJ.Text + 1
					aH.EditBoxCopying = false
				end

				av.ConnectEditBoxEvent = function(aH)
					if aH.EditBoxEvent then
						aH.EditBoxEvent:Disconnect()
					end

					aH.EditBoxEvent = al.UserInputService.InputBegan:Connect(function(aI)
						if aI.UserInputType ~= Enum.UserInputType.Keyboard then
							return
						end

						local aJ = Enum.KeyCode
						local aK = aI.KeyCode

						local function setupMove(aL, aM)
							local aN, aO
							aN = al.UserInputService.InputEnded:Connect(function(aQ)
								if aQ.KeyCode ~= aL then
									return
								end
								aN:Disconnect()
								aO = true
							end)
							aM()
							ap.FastWait(0.5)
							while not aO do
								aM()
								ap.FastWait(0.03)
							end
						end

						if aK == aJ.Down then
							setupMove(aJ.Down, function()
								aH.CursorX = aH.FloatCursorX
								aH.CursorY = aH.CursorY + 1
								aH:UpdateCursor()
								aH:JumpToCursor()
							end)
						elseif aK == aJ.Up then
							setupMove(aJ.Up, function()
								aH.CursorX = aH.FloatCursorX
								aH.CursorY = aH.CursorY - 1
								aH:UpdateCursor()
								aH:JumpToCursor()
							end)
						elseif aK == aJ.Left then
							setupMove(aJ.Left, function()
								local aL = aH.Lines[aH.CursorY + 1] or ""
								aH.CursorX = aH.CursorX - 1 - (aL:sub(aH.CursorX - 3, aH.CursorX) == aD and 3 or 0)
								if aH.CursorX < 0 then
									aH.CursorY = aH.CursorY - 1
									local aM = aH.Lines[aH.CursorY + 1] or ""
									aH.CursorX = #aM
								end
								aH.FloatCursorX = aH.CursorX
								aH:UpdateCursor()
								aH:JumpToCursor()
							end)
						elseif aK == aJ.Right then
							setupMove(aJ.Right, function()
								local aL = aH.Lines[aH.CursorY + 1] or ""
								aH.CursorX = aH.CursorX + 1 + (aL:sub(aH.CursorX + 1, aH.CursorX + 4) == aD and 3 or 0)
								if aH.CursorX > #aL then
									aH.CursorY = aH.CursorY + 1
									aH.CursorX = 0
								end
								aH.FloatCursorX = aH.CursorX
								aH:UpdateCursor()
								aH:JumpToCursor()
							end)
						elseif aK == aJ.Backspace then
							setupMove(aJ.Backspace, function()
								local aL, aM
								if aH:IsValidRange() then
									aL = aH.SelectionRange[1]
									aM = aH.SelectionRange[2]
								else
									aM = { aH.CursorX, aH.CursorY }
								end

								if not aL then
									local aN = aH.Lines[aH.CursorY + 1] or ""
									aH.CursorX = aH.CursorX - 1 - (aN:sub(aH.CursorX - 3, aH.CursorX) == aD and 3 or 0)
									if aH.CursorX < 0 then
										aH.CursorY = aH.CursorY - 1
										local aO = aH.Lines[aH.CursorY + 1] or ""
										aH.CursorX = #aO
									end
									aH.FloatCursorX = aH.CursorX
									aH:UpdateCursor()

									aL = aL or { aH.CursorX, aH.CursorY }
								end

								aH:DeleteRange({ aL, aM }, false, true)
								aH:ResetSelection(true)
								aH:JumpToCursor()
							end)
						elseif aK == aJ.Delete then
							setupMove(aJ.Delete, function()
								local aL, aM
								if aH:IsValidRange() then
									aL = aH.SelectionRange[1]
									aM = aH.SelectionRange[2]
								else
									aL = { aH.CursorX, aH.CursorY }
								end

								if not aM then
									local aN = aH.Lines[aH.CursorY + 1] or ""
									local aO = aH.CursorX + 1 + (aN:sub(aH.CursorX + 1, aH.CursorX + 4) == aD and 3 or 0)
									local aQ = aH.CursorY
									if aO > #aN then
										aQ = aQ + 1
										aO = 0
									end
									aH:UpdateCursor()

									aM = aM or { aO, aQ }
								end

								aH:DeleteRange({ aL, aM }, false, true)
								aH:ResetSelection(true)
								aH:JumpToCursor()
							end)
						elseif al.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
							if aK == aJ.A then
								aH.SelectionRange = { { 0, 0 }, { #aH.Lines[#aH.Lines], #aH.Lines - 1 } }
								aH:SetCopyableSelection()
								aH:Refresh()
							end
						end
					end)
				end

				av.DisconnectEditBoxEvent = function(aH)
					if aH.EditBoxEvent then
						aH.EditBoxEvent:Disconnect()
					end
				end

				av.ResetSelection = function(aH, aI)
					aH.SelectionRange = { { -1, -1 }, { -1, -1 } }
					if not aI then
						aH:Refresh()
					end
				end

				av.IsValidRange = function(aH, aI)
					local aJ = aI or aH.SelectionRange
					local aK, aL = aJ[1][1], aJ[1][2]
					local aM, aN = aJ[2][1], aJ[2][2]

					if aK == -1 or (aK == aM and aL == aN) then
						return false
					end

					return true
				end

				av.DeleteRange = function(aH, aI, aJ, aK)
					aI = aI or aH.SelectionRange
					if not aH:IsValidRange(aI) then
						return
					end

					local aL = aH.Lines
					local aM, aN = aI[1][1], aI[1][2]
					local aO, aQ = aI[2][1], aI[2][2]
					local aR = aQ - aN

					if not aL[aN + 1] or not aL[aQ + 1] then
						return
					end

					local l = aL[aN + 1]:sub(1, aM)
					local m = aL[aQ + 1]:sub(aO + 1)
					aL[aN + 1] = l .. m

					local n = table.remove
					for o = 1, aR do
						n(aL, aN + 2)
					end

					if aI == aH.SelectionRange then
						aH.SelectionRange = { { -1, -1 }, { -1, -1 } }
					end
					if aK then
						aH.CursorX = aM
						aH.CursorY = aN
						aH:UpdateCursor()
					end

					if not aJ then
						aH:ProcessTextChange()
					end
				end

				av.AppendText = function(aH, aI)
					aH:DeleteRange(nil, true, true)
					local aJ, aK, aL = aH.Lines, aH.CursorX, aH.CursorY
					local aM = aJ[aL + 1]
					local aN = aM:sub(1, aK)
					local aO = aM:sub(aK + 1)

					aI = aI:gsub("\r\n", "\n")
					aI = aH:ConvertText(aI, true)

					local aQ = aI:split("\n")
					local aR = table.insert

					for l = 1, #aQ do
						local m = aL + l
						if l > 1 then
							aR(aJ, m, "")
						end

						local n = aQ[l]
						local o = (l == 1 and aN or "")
						local p = (l == #aQ and aO or "")

						aJ[m] = o .. n .. p
					end

					if #aQ > 1 then
						aK = 0
					end

					aH:ProcessTextChange()
					aH.CursorX = aK + #aQ[#aQ]
					aH.CursorY = aL + #aQ - 1
					aH:UpdateCursor()
				end

				av.ScrollDelta = function(aH, aI, aJ)
					aH.ScrollV:ScrollTo(aH.ScrollV.Index + aJ)
					aH.ScrollH:ScrollTo(aH.ScrollH.Index + aI)
				end

				av.TabAdjust = function(aH, aI, aJ)
					local aK = aH.Lines
					local aL = aK[aJ + 1]
					aI = aI + 1

					if aL then
						local aM = aL:sub(aI - 1, aI - 1)
						local aN = aL:sub(aI, aI)
						local aO = aL:sub(aI + 1, aI + 1)
						local aQ = (#aM > 0 and aM or " ") .. (#aN > 0 and aN or " ") .. (#aO > 0 and aO or " ")

						for aR, l in pairs(aE) do
							if aQ:find(aR) then
								return l
							end
						end
					end
					return 0
				end

				av.SetEditing = function(aH, aI, aJ)
					aH:UpdateCursor(aJ)

					if aI then
						if aH.Editable then
							aH.GuiElems.EditBox.Text = ""
							aH.GuiElems.EditBox:CaptureFocus()
						end
					else
						aH.GuiElems.EditBox:ReleaseFocus()
					end
				end

				av.CursorAnim = function(aH, aI)
					local aJ = aH.GuiElems.Cursor
					local aK = tick()
					aH.LastAnimTime = aK

					if not aI then
						return
					end

					aG.Invis:Cancel()
					aG.Vis:Cancel()
					aJ.BackgroundTransparency = 0

					coroutine.wrap(function()
						while aH.Editable do
							ap.FastWait(0.5)
							if aH.LastAnimTime ~= aK then
								return
							end
							aG.Invis:Play()
							ap.FastWait(0.4)
							if aH.LastAnimTime ~= aK then
								return
							end
							aG.Vis:Play()
							ap.FastWait(0.2)
						end
					end)()
				end

				av.MoveCursor = function(aH, aI, aJ)
					aH.CursorX = aI
					aH.CursorY = aJ
					aH:UpdateCursor()
					aH:JumpToCursor()
				end

				av.JumpToCursor = function(aH)
					aH:Refresh()
				end

				av.UpdateCursor = function(aH, aI)
					local aJ = aH.GuiElems.LinesFrame
					local aK = aH.GuiElems.Cursor
					local aL = math.max(0, aJ.AbsoluteSize.X)
					local aM = math.max(0, aJ.AbsoluteSize.Y)
					local aN = math.ceil(aM / aH.FontSize)
					local aO = math.ceil(aL / math.ceil(aH.FontSize / 2))
					local aQ, aR = aH.ViewX, aH.ViewY
					local l = tostring(#aH.Lines)
					local m = math.ceil(aH.FontSize / 2)
					local n = #l * m + 4 * m

					if aI then
						local o = aH.GuiElems.LinesFrame
						local p, q = o.AbsolutePosition.X, o.AbsolutePosition.Y
						local r, s = aI.Position.X, aI.Position.Y
						local t, u = math.ceil(aH.FontSize / 2), aH.FontSize

						aH.CursorX = aH.ViewX + math.round((r - p) / t)
						aH.CursorY = aH.ViewY + math.floor((s - q) / u)
					end

					local o, p = aH.CursorX, aH.CursorY

					local q = aH.Lines[p + 1] or ""
					if o > #q then
						o = #q
					elseif o < 0 then
						o = 0
					end

					if p >= #aH.Lines then
						p = math.max(0, #aH.Lines - 1)
					elseif p < 0 then
						p = 0
					end

					o = o + aH:TabAdjust(o, p)

					aH.CursorX = o
					aH.CursorY = p

					local r = (o >= aQ) and (p >= aR) and (o <= aQ + aO) and (p <= aR + aN)
					if r then
						local s = (o - aQ)
						local t = (p - aR)
						aK.Position = UDim2.new(0, n + s * math.ceil(aH.FontSize / 2) - 1, 0, t * aH.FontSize)
						aK.Size = UDim2.new(0, 1, 0, aH.FontSize + 2)
						aK.Visible = true
						aH:CursorAnim(true)
					else
						aK.Visible = false
					end
				end

				av.MapNewLines = function(aH)
					local aI = {}
					local aJ = 1
					local aK = aH.Text
					local aL = string.find
					local aM = 1

					local aN = aL(aK, "\n", aM, true)
					while aN do
						aI[aJ] = aN
						aJ = aJ + 1
						aM = aN + 1
						aN = aL(aK, "\n", aM, true)
					end

					aH.NewLines = aI
				end

				av.PreHighlight = function(aH)
					tick()
					local aI = aH.Text:gsub("\\\\", "  ")

					local aJ = #aI
					local aK = {}
					local aL = {}
					local aM = {}
					local aN = string.find
					local aO = string.sub
					aH.ColoredLines = {}

					local function findAll(aQ, aR, l, m)
						local n = #aK + 1
						local o = 1
						local p, q, r = aN(aQ, aR, o, m)
						while p do
							aK[n] = p
							aL[p] = l
							if r then
								aM[p] = r
							end

							n = n + 1
							o = q + 1
							p, q, r = aN(aQ, aR, o, m)
						end
					end
					tick()
					findAll(aI, '"', 1, true)
					findAll(aI, "'", 2, true)
					findAll(aI, "%[(=*)%[", 3)
					findAll(aI, "--", 4, true)
					table.sort(aK)

					local aQ = aH.NewLines
					local aR = 0

					local l = 0
					local m = 0
					local n = {}

					for o = 1, #aK do
						local p = aK[o]
						if p <= m then
							continue
						end

						local q = p
						local r = aL[p]
						if r == 1 then
							q = aN(aI, '"', p + 1, true)
							while q and aO(aI, q - 1, q - 1) == "\\" do
								q = aN(aI, '"', q + 1, true)
							end
							if not q then
								q = aJ
							end
						elseif r == 2 then
							q = aN(aI, "'", p + 1, true)
							while q and aO(aI, q - 1, q - 1) == "\\" do
								q = aN(aI, "'", q + 1, true)
							end
							if not q then
								q = aJ
							end
						elseif r == 3 then
							_, q = aN(aI, "]" .. aM[p] .. "]", p + 1, true)
							if not q then
								q = aJ
							end
						elseif r == 4 then
							local s = aL[p + 2]

							if s == 3 then
								_, q = aN(aI, "]" .. aM[p + 2] .. "]", p + 1, true)
								if not q then
									q = aJ
								end
							else
								q = aN(aI, "\n", p + 1, true) or aJ
							end
						end

						while p > l do
							aR = aR + 1

							l = aQ[aR] or aJ + 1
						end
						while true do
							local s = n[aR]
							if not s then
								s = {}
								n[aR] = s
							end
							s[p] = { r, q }

							if q > l then
								aR = aR + 1
								l = aQ[aR] or aJ + 1
							else
								break
							end
						end

						m = q
					end
					aH.PreHighlights = n
				end

				av.HighlightLine = function(aH, aI)
					local aJ = aH.ColoredLines[aI]
					if aJ then
						return aJ
					end

					local aK = string.sub
					local aL = string.find
					local aM = string.match
					local aN = {}
					local aO = aH.PreHighlights[aI] or {}
					local aQ = aH.Lines[aI] or ""
					local aR = #aQ
					local l = 0
					local m = 0
					local n
					local o = false
					local p = 0
					local q = aH.NewLines[aI - 1] or 0

					local r = {}
					for s, t in next, aO do
						local u = s - q
						if u < 1 then
							m = t[1]
							l = t[2] - q
						else
							r[u] = { t[1], t[2] - q }
						end
					end

					for s = 1, #aQ do
						if s <= l then
							aN[s] = m
							continue
						end

						local t = r[s]
						if t then
							m = t[1]
							l = t[2]
							aN[s] = m
							o = false
							n = nil
							p = 0
						else
							local u = aK(aQ, s, s)
							if aL(u, "[%a_]") then
								local v = aM(aQ, "[%a%d_]+", s)
								local w = (ay[v] and 7) or (az[v] and 8)

								l = s + #v - 1

								if w ~= 7 then
									if o then
										local x = n and az[n]
										w = (x and type(x) == "table" and x[v] and 8) or 10
									end

									if w ~= 8 then
										local x, y, z = aL(aQ, "^%s*([%({\"'])", l + 1)
										if x then
											w = (p > 0 and z == "(" and 16) or 9
											p = 0
										end
									end
								else
									w = ax[v] or w
									p = (v == "function" and 1 or 0)
								end

								n = v
								o = false
								if p > 0 then
									p = 1
								end

								if w then
									m = w
									aN[s] = m
								else
									m = nil
								end
							elseif aL(u, "%p") then
								local v = (u == ".")
								local w = v and aL(aK(aQ, s + 1, s + 1), "%d")
								aN[s] = (w and 6 or 5)

								if not w then
									local x = v and aM(aQ, "%.%.?%.?", s)
									if x and #x > 1 then
										m = 5
										l = s + #x - 1
										o = false
										n = nil
										p = 0
									else
										if v then
											if o then
												n = nil
											else
												o = true
											end
										else
											o = false
											n = nil
										end

										p = ((v or u == ":") and p == 1 and 2) or 0
									end
								end
							elseif aL(u, "%d") then
								local v, w = aL(aQ, "%x+", s)
								local x = aK(aQ, w, w + 1)
								if (x == "e+" or x == "e-") and aL(aK(aQ, w + 2, w + 2), "%d") then
									w = w + 1
								end
								m = 6
								l = w
								aN[s] = 6
								o = false
								n = nil
								p = 0
							else
								aN[s] = m
								local v, w = aL(aQ, "%s+", s)
								if w then
									l = w
								end
							end
						end
					end

					aH.ColoredLines[aI] = aN
					return aN
				end

				av.Refresh = function(aH)
					tick()

					local aI = aH.Frame.Lines
					local aJ = math.max(0, aI.AbsoluteSize.X)
					local aK = math.max(0, aI.AbsoluteSize.Y)
					local aL = math.ceil(aK / aH.FontSize)
					local aM = math.ceil(aJ / math.ceil(aH.FontSize / 2))
					local aN = string.gsub
					local aO = string.sub

					local aQ, aR = aH.ViewX, aH.ViewY

					local l = ""

					for m = 1, aL do
						local n = aH.LineFrames[m]
						if not n then
							n = Instance.new("Frame")
							n.Name = "Line"
							n.Position = UDim2.new(0, 0, 0, (m - 1) * aH.FontSize)
							n.Size = UDim2.new(1, 0, 0, aH.FontSize)
							n.BorderSizePixel = 0
							n.BackgroundTransparency = 1

							local o = Instance.new("Frame")
							o.Name = "SelectionHighlight"
							o.BorderSizePixel = 0
							o.BackgroundColor3 = ad.Theme.Syntax.SelectionBack
							o.Parent = n

							local p = Instance.new("TextLabel")
							p.Name = "Label"
							p.BackgroundTransparency = 1
							p.Font = Enum.Font.Code
							p.TextSize = aH.FontSize
							p.Size = UDim2.new(1, 0, 0, aH.FontSize)
							p.RichText = true
							p.TextXAlignment = Enum.TextXAlignment.Left
							p.TextColor3 = aH.Colors.Text
							p.ZIndex = 2
							p.Parent = n

							n.Parent = aI
							aH.LineFrames[m] = n
						end

						local o = aR + m
						local p = aH.Lines[o] or ""
						local q = ""
						local r = aH:HighlightLine(o)
						local s = aQ + 1

						local t = aH.RichTemplates
						local u = t.Text
						local v = t.Selection
						local w = r[s]
						local x = t[aw[w]] or u

						local y = aH.SelectionRange
						local z = y[1]
						local A = y[2]
						local B, C = z[2], z[1]
						local D, E = A[2], A[1]
						local F = o - 1

						if F >= z[2] and F <= A[2] then
							local G = math.ceil(aH.FontSize / 2)
							local H = (F == z[2] and z[1] or 0) - aQ
							local I = (F == A[2] and A[1] - H - aQ or aM + aQ)

							n.SelectionHighlight.Position = UDim2.new(0, H * G, 0, 0)
							n.SelectionHighlight.Size = UDim2.new(0, I * G, 1, 0)
							n.SelectionHighlight.Visible = true
						else
							n.SelectionHighlight.Visible = false
						end

						local G = F >= B and F <= D and (F == B and aQ >= C or F ~= B) and (F == D and aQ < E or F ~= D)
						if G then
							w = -999
							x = v
						end

						for H = 2, aM do
							local I = aQ + H
							local J = I - 1
							local K = r[I]

							local L = F >= B and F <= D and (F == B and J >= C or F ~= B) and (F == D and J < E or F ~= D)
							if L then
								K = -999
							end

							if K ~= w then
								local M = (L and v) or t[aw[K]] or u

								if M ~= x then
									local N = aN(aO(p, s, I - 1), "['\"<>&]", aB)
									q = q .. (x ~= u and (x .. N .. "</font>") or N)
									s = I
									x = M
								end
								w = K
							end
						end

						local H = aN(aO(p, s, aQ + aM), "['\"<>&]", aB)

						if #H > 0 then
							q = q .. (x ~= u and (x .. H .. "</font>") or H)
						end

						if aH.Lines[o] then
							l = l .. (o == aH.CursorY and ("<b>" .. o .. "</b>\n") or o .. "\n")
						end

						n.Label.Text = q
					end

					for m = aL + 1, #aH.LineFrames do
						aH.LineFrames[m]:Destroy()
						aH.LineFrames[m] = nil
					end

					aH.Frame.LineNumbers.Text = l
					aH:UpdateCursor()
				end

				av.UpdateView = function(aH)
					local aI = tostring(#aH.Lines)
					local aJ = math.ceil(aH.FontSize / 2)
					local aK = #aI * aJ + 4 * aJ

					local aL = aH.Frame.Lines
					local aM = aL.AbsoluteSize.X
					local aN = aL.AbsoluteSize.Y
					local aO = math.ceil(aN / aH.FontSize)
					local aQ = aH.MaxTextCols * aJ
					local aR = aH.ScrollV
					local l = aH.ScrollH

					aR.VisibleSpace = aO
					aR.TotalSpace = #aH.Lines + 1
					l.VisibleSpace = math.ceil(aM / aJ)
					l.TotalSpace = aH.MaxTextCols + 1

					aR.Gui.Visible = #aH.Lines + 1 > aO
					l.Gui.Visible = aQ > aM

					local m = aH.FrameOffsets
					aH.FrameOffsets = Vector2.new(aR.Gui.Visible and -16 or 0, l.Gui.Visible and -16 or 0)
					if m ~= aH.FrameOffsets then
						aH:UpdateView()
					else
						aR:ScrollTo(aH.ViewY, true)
						l:ScrollTo(aH.ViewX, true)

						if aR.Gui.Visible and l.Gui.Visible then
							aR.Gui.Size = UDim2.new(0, 16, 1, -16)
							l.Gui.Size = UDim2.new(1, -16, 0, 16)
							aH.GuiElems.ScrollCorner.Visible = true
						else
							aR.Gui.Size = UDim2.new(0, 16, 1, 0)
							l.Gui.Size = UDim2.new(1, 0, 0, 16)
							aH.GuiElems.ScrollCorner.Visible = false
						end

						aH.ViewY = aR.Index
						aH.ViewX = l.Index
						aH.Frame.Lines.Position = UDim2.new(0, aK, 0, 0)
						aH.Frame.Lines.Size = UDim2.new(1, -aK + m.X, 1, m.Y)
						aH.Frame.LineNumbers.Position = UDim2.new(0, aJ, 0, 0)
						aH.Frame.LineNumbers.Size = UDim2.new(0, #aI * aJ, 1, m.Y)
						aH.Frame.LineNumbers.TextSize = aH.FontSize
					end
				end

				av.ProcessTextChange = function(aH)
					local aI = 0
					local aJ = aH.Lines

					for aK = 1, #aJ do
						local aL = #aJ[aK]
						if aL > aI then
							aI = aL
						end
					end

					aH.MaxTextCols = aI
					aH:UpdateView()
					aH.Text = table.concat(aH.Lines, "\n")
					aH:MapNewLines()
					aH:PreHighlight()
					aH:Refresh()
				end

				av.ConvertText = function(aH, aI, aJ)
					if aJ then
						return aI:gsub("\t", (" %s%s "):format(aC, aC))
					else
						return aI:gsub((" %s%s "):format(aC, aC), "\t")
					end
				end

				av.GetText = function(aH)
					local aI = table.concat(aH.Lines, "\n")
					return aH:ConvertText(aI, false)
				end

				av.SetText = function(aH, aI)
					aI = aH:ConvertText(aI, true)
					local aJ = aH.Lines
					table.clear(aJ)
					local aK = 1

					for aL in aI:gmatch("([^\n\r]*)[\n\r]?") do
						local aM = #aL
						aJ[aK] = aL
						aK = aK + 1
					end

					aH:ProcessTextChange()
				end

				av.MakeRichTemplates = function(aH)
					local aI = math.floor
					local aJ = {}

					for aK, aL in pairs(aH.Colors) do
						aJ[aK] = ('<font color="rgb(%s,%s,%s)">'):format(aI(aL.r * 255), aI(aL.g * 255), aI(aL.b * 255))
					end

					aH.RichTemplates = aJ
				end

				av.ApplyTheme = function(aH)
					local aI = ad.Theme.Syntax
					aH.Colors = aI
					aH.Frame.LineNumbers.TextColor3 = aI.Text
					aH.Frame.BackgroundColor3 = aI.Background
				end

				local aH = { __index = av }

				local function new()
					if not aA then
						initBuiltIn()
					end

					local aI = ap.ScrollBar.new()
					local aJ = ap.ScrollBar.new(true)
					aJ.Gui.Position = UDim2.new(0, 0, 1, -16)
					local aK = setmetatable({
						FontSize = 15,
						ViewX = 0,
						ViewY = 0,
						Colors = ad.Theme.Syntax,
						ColoredLines = {},
						Lines = { "" },
						LineFrames = {},
						Editable = true,
						Editing = false,
						CursorX = 0,
						CursorY = 0,
						FloatCursorX = 0,
						Text = "",
						PreHighlights = {},
						SelectionRange = { { -1, -1 }, { -1, -1 } },
						NewLines = {},
						FrameOffsets = Vector2.new(0, 0),
						MaxTextCols = 0,
						ScrollV = aI,
						ScrollH = aJ,
					}, aH)

					aI.WheelIncrement = 3
					aJ.Increment = 2
					aJ.WheelIncrement = 7

					aI.Scrolled:Connect(function()
						aK.ViewY = aI.Index
						aK:Refresh()
					end)

					aJ.Scrolled:Connect(function()
						aK.ViewX = aJ.Index
						aK:Refresh()
					end)

					makeFrame(aK)
					aK:MakeRichTemplates()
					aK:ApplyTheme()
					aI:SetScrollFrame(aK.Frame.Lines)
					aI.Gui.Parent = aK.Frame
					aJ.Gui.Parent = aK.Frame

					aK:UpdateView()
					aK.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						aK:UpdateView()
						aK:Refresh()
					end)

					return aK
				end

				return { new = new }
			end)()

			ap.Checkbox = (function()
				local av = {}
				local aw = Color3.fromRGB
				local ax = Vector2.new
				local ay = UDim2.fromScale
				local az = UDim2.fromOffset
				local aA = UDim.new
				local aB = math.max
				local aC = Instance.new
				local aD = aC("Frame").TweenSize
				local aE = TweenInfo.new
				local aF = delay

				local function ripple(aG, aH)
					local aI = aC("Frame")
					aI.BackgroundColor3 = aH
					aI.BackgroundTransparency = 0.75
					aI.BorderSizePixel = 0
					aI.AnchorPoint = ax(0.5, 0.5)
					aI.Size = az()
					aI.Position = ay(0.5, 0.5)
					aI.Parent = aG
					local aJ = aC("UICorner")
					aJ.CornerRadius = aA(1)
					aJ.Parent = aI

					local aK = aG.AbsoluteSize
					local aL = aB(aK.X, aK.Y) * 5 / 3

					aD(aI, az(aL, aL), "Out", "Quart", 0.4)
					al.TweenService:Create(aI, aE(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()

					al.Debris:AddItem(aI, 0.4)
				end

				local function initGui(aG, aH)
					local aI = aH
						or an({
							{ 1, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Checkbox", Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(0, 16, 0, 16) } },
							{ 2, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ripples", Parent = { 1 }, Size = UDim2.new(1, 0, 1, 0) } },
							{ 3, "Frame", { BackgroundColor3 = Color3.new(0.10196078568697, 0.10196078568697, 0.10196078568697), BorderSizePixel = 0, Name = "outline", Parent = { 1 }, Size = UDim2.new(0, 16, 0, 16) } },
							{ 4, "Frame", { BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462), BorderSizePixel = 0, Name = "filler", Parent = { 3 }, Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(0, 14, 0, 14) } },
							{ 5, "Frame", { BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196), BorderSizePixel = 0, Name = "top", Parent = { 4 }, Size = UDim2.new(0, 16, 0, 0) } },
							{ 6, "Frame", { AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196), BorderSizePixel = 0, Name = "bottom", Parent = { 4 }, Position = UDim2.new(0, 0, 0, 14), Size = UDim2.new(0, 16, 0, 0) } },
							{ 7, "Frame", { BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196), BorderSizePixel = 0, Name = "left", Parent = { 4 }, Size = UDim2.new(0, 0, 0, 16) } },
							{ 8, "Frame", { AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196), BorderSizePixel = 0, Name = "right", Parent = { 4 }, Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(0, 0, 0, 16) } },
							{ 9, "Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Name = "checkmark", Parent = { 4 }, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 20) } },
							{ 10, "ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = "rbxassetid://6234266378", Parent = { 9 }, Position = UDim2.new(0.5, 0, 0.5, 0), ScaleType = 3, Size = UDim2.new(0, 15, 0, 11) } },
							{ 11, "ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://6401617475", ImageColor3 = Color3.new(0.20784313976765, 0.69803923368454, 0.98431372642517), Name = "checkmark2", Parent = { 4 }, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12), Visible = false } },
							{ 12, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://6425281788", ImageTransparency = 0.20000000298023, Name = "middle", Parent = { 4 }, ScaleType = 2, Size = UDim2.new(1, 0, 1, 0), TileSize = UDim2.new(0, 2, 0, 2), Visible = false } },
							{ 13, "UICorner", { CornerRadius = UDim.new(0, 2), Parent = { 3 } } },
						})
					local aJ = aI.outline
					local aK = aJ.filler
					local aL = aK.checkmark
					local aM = aI.ripples

					local aN, aO, aQ, aR = aK.top, aK.bottom, aK.left, aK.right

					aG.Gui = aI
					aG.GuiElems = {
						Top = aN,
						Bottom = aO,
						Left = aQ,
						Right = aR,
						Outline = aJ,
						Filler = aK,
						Checkmark = aL,
						Checkmark2 = aK.checkmark2,
						Middle = aK.middle,
					}

					aI.InputBegan:Connect(function(l)
						if l.UserInputType == Enum.UserInputType.MouseButton1 then
							local m
							m = al.UserInputService.InputEnded:Connect(function(n)
								if n.UserInputType == Enum.UserInputType.MouseButton1 then
									m:Disconnect()

									if ap.CheckMouseInGui(aI) then
										if aG.Style == 0 then
											ripple(aM, aG.Disabled and aG.Colors.Disabled or aG.Colors.Primary)
										end

										if not aG.Disabled then
											aG:SetState(not aG.Toggled, true)
										else
											aG:Paint()
										end

										aG.OnInput:Fire()
									end
								end
							end)
						end
					end)

					aG:Paint()
				end

				av.Collapse = function(aG, aH)
					local aI = aG.GuiElems
					if aH then
						aD(aI.Top, az(14, 14), "In", "Quart", 0.26666666666666666, true)
						aD(aI.Bottom, az(14, 14), "In", "Quart", 0.26666666666666666, true)
						aD(aI.Left, az(14, 14), "In", "Quart", 0.26666666666666666, true)
						aD(aI.Right, az(14, 14), "In", "Quart", 0.26666666666666666, true)
					else
						aI.Top.Size = az(14, 14)
						aI.Bottom.Size = az(14, 14)
						aI.Left.Size = az(14, 14)
						aI.Right.Size = az(14, 14)
					end
				end

				av.Expand = function(aG, aH)
					local aI = aG.GuiElems
					if aH then
						aD(aI.Top, az(14, 0), "InOut", "Quart", 0.26666666666666666, true)
						aD(aI.Bottom, az(14, 0), "InOut", "Quart", 0.26666666666666666, true)
						aD(aI.Left, az(0, 14), "InOut", "Quart", 0.26666666666666666, true)
						aD(aI.Right, az(0, 14), "InOut", "Quart", 0.26666666666666666, true)
					else
						aI.Top.Size = az(14, 0)
						aI.Bottom.Size = az(14, 0)
						aI.Left.Size = az(0, 14)
						aI.Right.Size = az(0, 14)
					end
				end

				av.Paint = function(aG)
					local aH = aG.GuiElems

					if aG.Style == 0 then
						local aI = aG.Disabled and aG.Colors.Disabled
						aH.Outline.BackgroundColor3 = aI or (aG.Toggled and aG.Colors.Primary) or aG.Colors.Secondary
						local aJ = aI or aG.Colors.Primary
						aH.Top.BackgroundColor3 = aJ
						aH.Bottom.BackgroundColor3 = aJ
						aH.Left.BackgroundColor3 = aJ
						aH.Right.BackgroundColor3 = aJ
					else
						aH.Outline.BackgroundColor3 = aG.Disabled and aG.Colors.Disabled or aG.Colors.Secondary
						aH.Filler.BackgroundColor3 = aG.Disabled and aG.Colors.DisabledBackground or aG.Colors.Background
						aH.Checkmark2.ImageColor3 = aG.Disabled and aG.Colors.DisabledCheck or aG.Colors.Primary
					end
				end

				av.SetState = function(aG, aH, aI)
					aG.Toggled = aH

					if aG.OutlineColorTween then
						aG.OutlineColorTween:Cancel()
					end
					local aJ = tick()
					aG.LastSetStateTime = aJ

					if aG.Toggled then
						if aG.Style == 0 then
							if aI then
								aG.OutlineColorTween = al.TweenService:Create(aG.GuiElems.Outline, aE(0.26666666666666666, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), { BackgroundColor3 = aG.Colors.Primary })
								aG.OutlineColorTween:Play()
								aF(0.15, function()
									if aJ ~= aG.LastSetStateTime then
										return
									end
									aG:Paint()
									aD(aG.GuiElems.Checkmark, az(14, 20), "Out", "Bounce", 0.13333333333333333, true)
								end)
							else
								aG.GuiElems.Outline.BackgroundColor3 = aG.Colors.Primary
								aG:Paint()
								aG.GuiElems.Checkmark.Size = az(14, 20)
							end
							aG:Collapse(aI)
						else
							aG:Paint()
							aG.GuiElems.Checkmark2.Visible = true
							aG.GuiElems.Middle.Visible = false
						end
					else
						if aG.Style == 0 then
							if aI then
								aG.OutlineColorTween = al.TweenService:Create(aG.GuiElems.Outline, aE(0.26666666666666666, Enum.EasingStyle.Circular, Enum.EasingDirection.In), { BackgroundColor3 = aG.Colors.Secondary })
								aG.OutlineColorTween:Play()
								aF(0.15, function()
									if aJ ~= aG.LastSetStateTime then
										return
									end
									aG:Paint()
									aD(aG.GuiElems.Checkmark, az(0, 20), "Out", "Quad", 6.666666666666666E-2, true)
								end)
							else
								aG.GuiElems.Outline.BackgroundColor3 = aG.Colors.Secondary
								aG:Paint()
								aG.GuiElems.Checkmark.Size = az(0, 20)
							end
							aG:Expand(aI)
						else
							aG:Paint()
							aG.GuiElems.Checkmark2.Visible = false
							aG.GuiElems.Middle.Visible = aG.Toggled == nil
						end
					end
				end

				local aG = { __index = av }

				local function new(aH)
					local aI = setmetatable({
						Toggled = false,
						Disabled = false,
						OnInput = ap.Signal.new(),
						Style = aH or 0,
						Colors = {
							Background = aw(36, 36, 36),
							Primary = aw(49, 176, 230),
							Secondary = aw(25, 25, 25),
							Disabled = aw(64, 64, 64),
							DisabledBackground = aw(52, 52, 52),
							DisabledCheck = aw(80, 80, 80),
						},
					}, aG)
					initGui(aI)
					return aI
				end

				local function fromFrame(aH)
					local aI = setmetatable({
						Toggled = false,
						Disabled = false,
						Colors = {
							Background = aw(36, 36, 36),
							Primary = aw(49, 176, 230),
							Secondary = aw(25, 25, 25),
							Disabled = aw(64, 64, 64),
							DisabledBackground = aw(52, 52, 52),
						},
					}, aG)
					initGui(aI, aH)
					return aI
				end

				return { new = new, fromFrame }
			end)()

			ap.BrickColorPicker = (function()
				local av = {}
				local aw = 0
				local ax = al.Players.LocalPlayer:GetMouse()
				local ay = 4
				local az = 27
				local aA = 1
				local aB = 8

				local aD = {
					Color3.fromRGB(17, 17, 17),
					Color3.fromRGB(99, 95, 98),
					Color3.fromRGB(163, 162, 165),
					Color3.fromRGB(205, 205, 205),
					Color3.fromRGB(223, 223, 222),
					Color3.fromRGB(237, 234, 234),
					Color3.fromRGB(27, 42, 53),
					Color3.fromRGB(91, 93, 105),
					Color3.fromRGB(159, 161, 172),
					Color3.fromRGB(202, 203, 209),
					Color3.fromRGB(231, 231, 236),
					Color3.fromRGB(248, 248, 248),
				}

				local function isMouseInHexagon(aE)
					local aF = ax.X - aE.AbsolutePosition.X
					local aG = ax.Y - aE.AbsolutePosition.Y
					if aF >= ay and aF < ay + az then
						aF = aF - 4
						local aH = (13 - math.min(aF, 26 - aF)) / 13
						if aG >= aA + aB * aH and aG < aE.AbsoluteSize.Y - aA - aB * aH then
							return true
						end
					end

					return false
				end

				local function hexInput(aE, aF, aG)
					aF.InputBegan:Connect(function(aH)
						if aH.UserInputType == Enum.UserInputType.MouseButton1 and isMouseInHexagon(aF) then
							aE.OnSelect:Fire(aG)
							aE:Close()
						end
					end)

					aF.InputChanged:Connect(function(aH)
						if aH.UserInputType == Enum.UserInputType.MouseMovement and isMouseInHexagon(aF) then
							aE.OnPreview:Fire(aG)
						end
					end)
				end

				local function createGui(aE)
					local aF = an({
						{ 1, "ScreenGui", { Name = "BrickColor" } },
						{ 2, "Frame", { Active = true, BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935), Parent = { 1 }, Position = UDim2.new(0.40000000596046, 0, 0.40000000596046, 0), Size = UDim2.new(0, 337, 0, 380) } },
						{ 3, "TextButton", { BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), BorderSizePixel = 0, Font = 3, Name = "MoreColors", Parent = { 2 }, Position = UDim2.new(0, 5, 1, -30), Size = UDim2.new(1, -10, 0, 25), Text = "More Colors", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
						{ 4, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = "rbxassetid://1281023007", ImageColor3 = Color3.new(0.33333334326744, 0.33333334326744, 0.49803924560547), Name = "Hex", Parent = { 2 }, Size = UDim2.new(0, 35, 0, 35), Visible = false } },
					})
					local aG = aF.Frame
					local aH = aG.Hex

					for aI = 1, 13 do
						local aJ = math.min(aI, 14 - aI) + 6
						for aK = 1, aJ do
							local aL = BrickColor.palette(aw).Color
							local aM = aH:Clone()
							aM.Position = UDim2.new(0, (aK - 1) * 25 - (aJ - 7) * 13 + 78 + 1, 0, (aI - 1) * 23 + 4)
							aM.ImageColor3 = aL
							aM.Visible = true
							hexInput(aE, aM, aL)
							aM.Parent = aG
							aw = aw + 1
						end
					end

					for aI = 1, 12 do
						local aJ = aD[aI]
						local aK = aH:Clone()
						aK.Position = UDim2.new(0, (aI - 1) * 25 - 65 + 78 + 3, 0, 308)
						aK.ImageColor3 = aJ
						aK.Visible = true
						hexInput(aE, aK, aJ)
						aK.Parent = aG
						aw = aw + 1
					end

					aG.MoreColors.MouseButton1Click:Connect(function()
						aE.OnMoreColors:Fire()
						aE:Close()
					end)

					aE.Gui = aF
				end

				av.SetMoreColorsVisible = function(aE, aF)
					local aG = aE.Gui.Frame
					aG.Size = UDim2.new(0, 337, 0, 380 - (not aF and 33 or 0))
					aG.MoreColors.Visible = aF
				end

				av.Show = function(aE, aF, aG, aH)
					aE.PrevColor = aH or aE.PrevColor

					local aI = false

					local aJ, aK = aF or ax.X, aG or ax.Y
					local aL, aM = ax.ViewSizeX, ax.ViewSizeY
					ap.ShowGui(aE.Gui)
					local aN, aO = aE.Gui.Frame.AbsoluteSize.X, aE.Gui.Frame.AbsoluteSize.Y

					if aJ + aN > aL then
						aJ = aE.ReverseX and aJ - aN or aL - aN
					end
					if aK + aO > aM then
						aI = true
					end

					local aQ = false
					if aE.CloseEvent then
						aE.CloseEvent:Disconnect()
					end
					aE.CloseEvent = al.UserInputService.InputBegan:Connect(function(aR)
						if not aQ or aR.UserInputType ~= Enum.UserInputType.MouseButton1 then
							return
						end

						if not ap.CheckMouseInGui(aE.Gui.Frame) then
							aE.CloseEvent:Disconnect()
							aE:Close()
						end
					end)

					if aI then
						local aR = aK - aO - (aE.ReverseYOffset or 0)
						aK = aR >= 0 and aR or 0
					end

					aE.Gui.Frame.Position = UDim2.new(0, aJ, 0, aK)

					ap.FastWait()
					aQ = true
				end

				av.Close = function(aE)
					aE.Gui.Parent = nil
					aE.OnCancel:Fire()
				end

				local aE = { __index = av }

				local function new()
					local aF = setmetatable({
						OnPreview = ap.Signal.new(),
						OnSelect = ap.Signal.new(),
						OnCancel = ap.Signal.new(),
						OnMoreColors = ap.Signal.new(),
						PrevColor = Color3.new(0, 0, 0),
					}, aE)
					createGui(aF)
					return aF
				end

				return { new = new }
			end)()

			ap.ColorPicker = (function()
				local function new()
					local av = setmetatable({}, {})

					av.OnSelect = ap.Signal.new()
					av.OnCancel = ap.Signal.new()
					av.OnPreview = ap.Signal.new()

					local aw = an({
						{ 1, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0, ClipsDescendants = true, Name = "Content", Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 1, -20) } },
						{ 2, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "BasicColors", Parent = { 1 }, Position = UDim2.new(0, 5, 0, 5), Size = UDim2.new(0, 180, 0, 200) } },
						{ 3, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 2 }, Position = UDim2.new(0, 0, 0, -5), Size = UDim2.new(1, 0, 0, 26), Text = "Basic Colors", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 4, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Blue", Parent = { 1 }, Position = UDim2.new(1, -63, 0, 255), Size = UDim2.new(0, 52, 0, 16) } },
						{ 5, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Font = 3, Name = "Input", Parent = { 4 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 50, 0, 16), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 6, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 5 }, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0) } },
						{ 7, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Up", Parent = { 6 }, Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 8, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 7 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 9, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 8 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 1) } },
						{ 10, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 8 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 11, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 8 }, Position = UDim2.new(0, 6, 0, 5), Size = UDim2.new(0, 5, 0, 1) } },
						{ 12, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Down", Parent = { 6 }, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 13, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 12 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 14, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 13 }, Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(0, 1, 0, 1) } },
						{ 15, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 13 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 16, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 13 }, Position = UDim2.new(0, 6, 0, 3), Size = UDim2.new(0, 5, 0, 1) } },
						{ 17, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 4 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Blue:", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 18, "Frame", { BackgroundColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), BorderSizePixel = 0, ClipsDescendants = true, Name = "ColorSpaceFrame", Parent = { 1 }, Position = UDim2.new(1, -261, 0, 4), Size = UDim2.new(0, 222, 0, 202) } },
						{ 19, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), BorderSizePixel = 0, Image = "rbxassetid://1072518406", Name = "ColorSpace", Parent = { 18 }, Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(0, 220, 0, 200) } },
						{ 20, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Scope", Parent = { 19 }, Position = UDim2.new(0, 210, 0, 190), Size = UDim2.new(0, 20, 0, 20) } },
						{ 21, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Name = "Line", Parent = { 20 }, Position = UDim2.new(0, 9, 0, 0), Size = UDim2.new(0, 2, 0, 20) } },
						{ 22, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Name = "Line", Parent = { 20 }, Position = UDim2.new(0, 0, 0, 9), Size = UDim2.new(0, 20, 0, 2) } },
						{ 23, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "CustomColors", Parent = { 1 }, Position = UDim2.new(0, 5, 0, 210), Size = UDim2.new(0, 180, 0, 90) } },
						{ 24, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 23 }, Size = UDim2.new(1, 0, 0, 20), Text = "Custom Colors (RC = Set)", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 25, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Green", Parent = { 1 }, Position = UDim2.new(1, -63, 0, 233), Size = UDim2.new(0, 52, 0, 16) } },
						{ 26, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Font = 3, Name = "Input", Parent = { 25 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 50, 0, 16), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 27, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 26 }, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0) } },
						{ 28, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Up", Parent = { 27 }, Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 29, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 28 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 30, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 29 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 1) } },
						{ 31, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 29 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 32, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 29 }, Position = UDim2.new(0, 6, 0, 5), Size = UDim2.new(0, 5, 0, 1) } },
						{ 33, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Down", Parent = { 27 }, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 34, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 33 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 35, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 34 }, Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(0, 1, 0, 1) } },
						{ 36, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 34 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 37, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 34 }, Position = UDim2.new(0, 6, 0, 3), Size = UDim2.new(0, 5, 0, 1) } },
						{ 38, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 25 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Green:", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 39, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Hue", Parent = { 1 }, Position = UDim2.new(1, -180, 0, 211), Size = UDim2.new(0, 52, 0, 16) } },
						{ 40, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Font = 3, Name = "Input", Parent = { 39 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 50, 0, 16), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 41, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 40 }, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0) } },
						{ 42, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Up", Parent = { 41 }, Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 43, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 42 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 44, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 43 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 1) } },
						{ 45, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 43 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 46, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 43 }, Position = UDim2.new(0, 6, 0, 5), Size = UDim2.new(0, 5, 0, 1) } },
						{ 47, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Down", Parent = { 41 }, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 48, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 47 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 49, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 48 }, Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(0, 1, 0, 1) } },
						{ 50, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 48 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 51, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 48 }, Position = UDim2.new(0, 6, 0, 3), Size = UDim2.new(0, 5, 0, 1) } },
						{ 52, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 39 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Hue:", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 53, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Name = "Preview", Parent = { 1 }, Position = UDim2.new(1, -260, 0, 211), Size = UDim2.new(0, 35, 1, -245) } },
						{ 54, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Red", Parent = { 1 }, Position = UDim2.new(1, -63, 0, 211), Size = UDim2.new(0, 52, 0, 16) } },
						{ 55, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Font = 3, Name = "Input", Parent = { 54 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 50, 0, 16), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 56, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 55 }, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0) } },
						{ 57, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Up", Parent = { 56 }, Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 58, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 57 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 59, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 58 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 1) } },
						{ 60, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 58 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 61, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 58 }, Position = UDim2.new(0, 6, 0, 5), Size = UDim2.new(0, 5, 0, 1) } },
						{ 62, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Down", Parent = { 56 }, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 63, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 62 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 64, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 63 }, Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(0, 1, 0, 1) } },
						{ 65, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 63 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 66, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 63 }, Position = UDim2.new(0, 6, 0, 3), Size = UDim2.new(0, 5, 0, 1) } },
						{ 67, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 54 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Red:", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 68, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Sat", Parent = { 1 }, Position = UDim2.new(1, -180, 0, 233), Size = UDim2.new(0, 52, 0, 16) } },
						{ 69, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Font = 3, Name = "Input", Parent = { 68 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 50, 0, 16), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 70, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 69 }, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0) } },
						{ 71, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Up", Parent = { 70 }, Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 72, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 71 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 73, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 72 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 1) } },
						{ 74, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 72 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 75, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 72 }, Position = UDim2.new(0, 6, 0, 5), Size = UDim2.new(0, 5, 0, 1) } },
						{ 76, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Down", Parent = { 70 }, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 77, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 76 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 78, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 77 }, Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(0, 1, 0, 1) } },
						{ 79, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 77 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 80, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 77 }, Position = UDim2.new(0, 6, 0, 3), Size = UDim2.new(0, 5, 0, 1) } },
						{ 81, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 68 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Sat:", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 82, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Val", Parent = { 1 }, Position = UDim2.new(1, -180, 0, 255), Size = UDim2.new(0, 52, 0, 16) } },
						{ 83, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Font = 3, Name = "Input", Parent = { 82 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 50, 0, 16), Text = "255", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 84, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 83 }, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0) } },
						{ 85, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Up", Parent = { 84 }, Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 86, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 85 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 87, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 86 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 1) } },
						{ 88, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 86 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 89, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 86 }, Position = UDim2.new(0, 6, 0, 5), Size = UDim2.new(0, 5, 0, 1) } },
						{ 90, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "Down", Parent = { 84 }, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 8), Text = "", TextSize = 14 } },
						{ 91, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 90 }, Size = UDim2.new(0, 16, 0, 8) } },
						{ 92, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 91 }, Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(0, 1, 0, 1) } },
						{ 93, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 91 }, Position = UDim2.new(0, 7, 0, 4), Size = UDim2.new(0, 3, 0, 1) } },
						{ 94, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 91 }, Position = UDim2.new(0, 6, 0, 3), Size = UDim2.new(0, 5, 0, 1) } },
						{ 95, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 82 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Val:", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 96, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Font = 3, Name = "Cancel", Parent = { 1 }, Position = UDim2.new(1, -105, 1, -28), Size = UDim2.new(0, 100, 0, 25), Text = "Cancel", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 97, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Font = 3, Name = "Ok", Parent = { 1 }, Position = UDim2.new(1, -210, 1, -28), Size = UDim2.new(0, 100, 0, 25), Text = "OK", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 98, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Image = "rbxassetid://1072518502", Name = "ColorStrip", Parent = { 1 }, Position = UDim2.new(1, -30, 0, 5), Size = UDim2.new(0, 13, 0, 200) } },
						{ 99, "Frame", { BackgroundColor3 = Color3.new(0.3137255012989, 0.3137255012989, 0.3137255012989), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ArrowFrame", Parent = { 1 }, Position = UDim2.new(1, -16, 0, 1), Size = UDim2.new(0, 5, 0, 208) } },
						{ 100, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 99 }, Position = UDim2.new(0, -2, 0, -4), Size = UDim2.new(0, 8, 0, 16) } },
						{ 101, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = { 100 }, Position = UDim2.new(0, 2, 0, 8), Size = UDim2.new(0, 1, 0, 1) } },
						{ 102, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = { 100 }, Position = UDim2.new(0, 3, 0, 7), Size = UDim2.new(0, 1, 0, 3) } },
						{ 103, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = { 100 }, Position = UDim2.new(0, 4, 0, 6), Size = UDim2.new(0, 1, 0, 5) } },
						{ 104, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = { 100 }, Position = UDim2.new(0, 5, 0, 5), Size = UDim2.new(0, 1, 0, 7) } },
						{ 105, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = { 100 }, Position = UDim2.new(0, 6, 0, 4), Size = UDim2.new(0, 1, 0, 9) } },
					})
					local ax = ap.Window.new()
					ax.Resizable = false
					ax.Alignable = false
					ax:SetTitle("Color Picker")
					ax:Resize(450, 330)
					for ay, az in pairs(aw:GetChildren()) do
						az.Parent = ax.GuiElems.Content
					end
					av.Window = ax
					av.Gui = ax.Gui
					local ay = ax.Gui.Main
					local az = ay.TopBar
					local aA = ay.Content
					local aB = aA.ColorSpaceFrame.ColorSpace
					local aD = aA.ColorStrip
					local aE = aA.Preview
					local aF = aA.BasicColors
					local aG = aA.CustomColors
					local aH = aA.Ok
					local aI = aA.Cancel
					local aJ = az.Close

					local aK = aB.Scope
					local aL = aA.ArrowFrame.Arrow

					local aM = aA.Hue.Input
					local aN = aA.Sat.Input
					local aO = aA.Val.Input

					local aQ = aA.Red.Input
					local aR = aA.Green.Input
					local l = aA.Blue.Input

					local m = i(game:GetService("UserInputService"))
					local n = i(game:GetService("Players")).LocalPlayer:GetMouse()

					local o, p, q = 0, 0, 1
					local r, s, t = 1, 1, 1
					local u = Color3.new(0, 0, 0)

					local v = {
						Color3.new(0, 0, 0),
						Color3.new(0.66666668653488, 0, 0),
						Color3.new(0, 0.33333334326744, 0),
						Color3.new(0.66666668653488, 0.33333334326744, 0),
						Color3.new(0, 0.66666668653488, 0),
						Color3.new(0.66666668653488, 0.66666668653488, 0),
						Color3.new(0, 1, 0),
						Color3.new(0.66666668653488, 1, 0),
						Color3.new(0, 0, 0.49803924560547),
						Color3.new(0.66666668653488, 0, 0.49803924560547),
						Color3.new(0, 0.33333334326744, 0.49803924560547),
						Color3.new(0.66666668653488, 0.33333334326744, 0.49803924560547),
						Color3.new(0, 0.66666668653488, 0.49803924560547),
						Color3.new(0.66666668653488, 0.66666668653488, 0.49803924560547),
						Color3.new(0, 1, 0.49803924560547),
						Color3.new(0.66666668653488, 1, 0.49803924560547),
						Color3.new(0, 0, 1),
						Color3.new(0.66666668653488, 0, 1),
						Color3.new(0, 0.33333334326744, 1),
						Color3.new(0.66666668653488, 0.33333334326744, 1),
						Color3.new(0, 0.66666668653488, 1),
						Color3.new(0.66666668653488, 0.66666668653488, 1),
						Color3.new(0, 1, 1),
						Color3.new(0.66666668653488, 1, 1),
						Color3.new(0.33333334326744, 0, 0),
						Color3.new(1, 0, 0),
						Color3.new(0.33333334326744, 0.33333334326744, 0),
						Color3.new(1, 0.33333334326744, 0),
						Color3.new(0.33333334326744, 0.66666668653488, 0),
						Color3.new(1, 0.66666668653488, 0),
						Color3.new(0.33333334326744, 1, 0),
						Color3.new(1, 1, 0),
						Color3.new(0.33333334326744, 0, 0.49803924560547),
						Color3.new(1, 0, 0.49803924560547),
						Color3.new(0.33333334326744, 0.33333334326744, 0.49803924560547),
						Color3.new(1, 0.33333334326744, 0.49803924560547),
						Color3.new(0.33333334326744, 0.66666668653488, 0.49803924560547),
						Color3.new(1, 0.66666668653488, 0.49803924560547),
						Color3.new(0.33333334326744, 1, 0.49803924560547),
						Color3.new(1, 1, 0.49803924560547),
						Color3.new(0.33333334326744, 0, 1),
						Color3.new(1, 0, 1),
						Color3.new(0.33333334326744, 0.33333334326744, 1),
						Color3.new(1, 0.33333334326744, 1),
						Color3.new(0.33333334326744, 0.66666668653488, 1),
						Color3.new(1, 0.66666668653488, 1),
						Color3.new(0.33333334326744, 1, 1),
						Color3.new(1, 1, 1),
					}
					local w = {}

					local function updateColor(x)
						local y, z, A = 219 - o * 219, 199 - p * 199, 199 - q * 199
						Color3.fromHSV(o, p, q)

						if x == 2 or not x then
							aM.Text = tostring(math.ceil(359 * o))
							aN.Text = tostring(math.ceil(255 * p))
							aO.Text = tostring(math.floor(255 * q))
						end
						if x == 1 or not x then
							aQ.Text = tostring(math.floor(255 * r))
							aR.Text = tostring(math.floor(255 * s))
							l.Text = tostring(math.floor(255 * t))
						end

						u = Color3.new(r, s, t)

						aK.Position = UDim2.new(0, y - 9, 0, z - 9)
						aD.ImageColor3 = Color3.fromHSV(o, p, 1)
						aL.Position = UDim2.new(0, -2, 0, A - 4)
						aE.BackgroundColor3 = u

						av.Color = u
						av.OnPreview:Fire(u)
					end

					local function colorSpaceInput()
						local x = n.X - aB.AbsolutePosition.X
						local y = n.Y - aB.AbsolutePosition.Y

						if x < 0 then
							x = 0
						elseif x > 219 then
							x = 219
						end
						if y < 0 then
							y = 0
						elseif y > 199 then
							y = 199
						end

						o = (219 - x) / 219
						p = (199 - y) / 199

						local z = Color3.fromHSV(o, p, q)
						r, s, t = z.r, z.g, z.b

						updateColor()
					end

					local function colorStripInput()
						local x = n.Y - aD.AbsolutePosition.Y

						if x < 0 then
							x = 0
						elseif x > 199 then
							x = 199
						end

						q = (199 - x) / 199

						local y = Color3.fromHSV(o, p, q)
						r, s, t = y.r, y.g, y.b

						updateColor()
					end

					local function hookButtons(x, y)
						x.ArrowFrame.Up.InputBegan:Connect(function(z)
							if z.UserInputType == Enum.UserInputType.MouseMovement then
								x.ArrowFrame.Up.BackgroundTransparency = 0.5
							elseif z.UserInputType == Enum.UserInputType.MouseButton1 then
								local A = tick()
								local B = true
								local C = tonumber(x.Text)

								if not C then
									return
								end

								releaseEvent = m.InputEnded:Connect(function(D)
									if D.UserInputType ~= Enum.UserInputType.MouseButton1 then
										return
									end
									releaseEvent:Disconnect()
									B = false
								end)

								C = C + 1
								y(C)
								while B do
									if tick() - A > 0.3 then
										C = C + 1
										y(C)
									end
									wait(0.1)
								end
							end
						end)

						x.ArrowFrame.Up.InputEnded:Connect(function(z)
							if z.UserInputType == Enum.UserInputType.MouseMovement then
								x.ArrowFrame.Up.BackgroundTransparency = 1
							end
						end)

						x.ArrowFrame.Down.InputBegan:Connect(function(z)
							if z.UserInputType == Enum.UserInputType.MouseMovement then
								x.ArrowFrame.Down.BackgroundTransparency = 0.5
							elseif z.UserInputType == Enum.UserInputType.MouseButton1 then
								local A = tick()
								local B = true
								local C = tonumber(x.Text)

								if not C then
									return
								end

								releaseEvent = m.InputEnded:Connect(function(D)
									if D.UserInputType ~= Enum.UserInputType.MouseButton1 then
										return
									end
									releaseEvent:Disconnect()
									B = false
								end)

								C = C - 1
								y(C)
								while B do
									if tick() - A > 0.3 then
										C = C - 1
										y(C)
									end
									wait(0.1)
								end
							end
						end)

						x.ArrowFrame.Down.InputEnded:Connect(function(z)
							if z.UserInputType == Enum.UserInputType.MouseMovement then
								x.ArrowFrame.Down.BackgroundTransparency = 1
							end
						end)
					end

					aB.InputBegan:Connect(function(x)
						if x.UserInputType == Enum.UserInputType.MouseButton1 then
							local y, z

							y = m.InputEnded:Connect(function(A)
								if A.UserInputType ~= Enum.UserInputType.MouseButton1 then
									return
								end
								y:Disconnect()
								z:Disconnect()
							end)

							z = m.InputChanged:Connect(function(A)
								if A.UserInputType == Enum.UserInputType.MouseMovement then
									colorSpaceInput()
								end
							end)

							colorSpaceInput()
						end
					end)

					aD.InputBegan:Connect(function(x)
						if x.UserInputType == Enum.UserInputType.MouseButton1 then
							local y, z

							y = m.InputEnded:Connect(function(A)
								if A.UserInputType ~= Enum.UserInputType.MouseButton1 then
									return
								end
								y:Disconnect()
								z:Disconnect()
							end)

							z = m.InputChanged:Connect(function(A)
								if A.UserInputType == Enum.UserInputType.MouseMovement then
									colorStripInput()
								end
							end)

							colorStripInput()
						end
					end)

					local function updateHue(x)
						local y = tonumber(x)
						if y then
							o = math.clamp(math.floor(y), 0, 359) / 359
							local z = Color3.fromHSV(o, p, q)
							r, s, t = z.r, z.g, z.b
							aM.Text = tostring(o * 359)
							updateColor(1)
						end
					end
					aM.FocusLost:Connect(function()
						updateHue(aM.Text)
					end)
					hookButtons(aM, updateHue)

					local function updateSat(x)
						local y = tonumber(x)
						if y then
							p = math.clamp(math.floor(y), 0, 255) / 255
							local z = Color3.fromHSV(o, p, q)
							r, s, t = z.r, z.g, z.b
							aN.Text = tostring(p * 255)
							updateColor(1)
						end
					end
					aN.FocusLost:Connect(function()
						updateSat(aN.Text)
					end)
					hookButtons(aN, updateSat)

					local function updateVal(x)
						local y = tonumber(x)
						if y then
							q = math.clamp(math.floor(y), 0, 255) / 255
							local z = Color3.fromHSV(o, p, q)
							r, s, t = z.r, z.g, z.b
							aO.Text = tostring(q * 255)
							updateColor(1)
						end
					end
					aO.FocusLost:Connect(function()
						updateVal(aO.Text)
					end)
					hookButtons(aO, updateVal)

					local function updateRed(x)
						local y = tonumber(x)
						if y then
							r = math.clamp(math.floor(y), 0, 255) / 255
							local z = Color3.new(r, s, t)
							o, p, q = Color3.toHSV(z)
							aQ.Text = tostring(r * 255)
							updateColor(2)
						end
					end
					aQ.FocusLost:Connect(function()
						updateRed(aQ.Text)
					end)
					hookButtons(aQ, updateRed)

					local function updateGreen(x)
						local y = tonumber(x)
						if y then
							s = math.clamp(math.floor(y), 0, 255) / 255
							local z = Color3.new(r, s, t)
							o, p, q = Color3.toHSV(z)
							aR.Text = tostring(s * 255)
							updateColor(2)
						end
					end
					aR.FocusLost:Connect(function()
						updateGreen(aR.Text)
					end)
					hookButtons(aR, updateGreen)

					local function updateBlue(x)
						local y = tonumber(x)
						if y then
							t = math.clamp(math.floor(y), 0, 255) / 255
							local z = Color3.new(r, s, t)
							o, p, q = Color3.toHSV(z)
							l.Text = tostring(t * 255)
							updateColor(2)
						end
					end
					l.FocusLost:Connect(function()
						updateBlue(l.Text)
					end)
					hookButtons(l, updateBlue)

					local x = Instance.new("TextButton")
					x.Name = "Choice"
					x.Size = UDim2.new(0, 25, 0, 18)
					x.BorderColor3 = Color3.fromRGB(55, 55, 55)
					x.Text = ""
					x.AutoButtonColor = false

					local y = 0
					local z = 0
					for A, B in pairs(v) do
						local C = x:Clone()
						C.BackgroundColor3 = B
						C.Position = UDim2.new(0, 1 + 30 * z, 0, 21 + 23 * y)

						C.MouseButton1Click:Connect(function()
							r, s, t = B.r, B.g, B.b
							local D = Color3.new(r, s, t)
							o, p, q = Color3.toHSV(D)
							updateColor()
						end)

						C.Parent = aF
						z = z + 1
						if z == 6 then
							y = y + 1
							z = 0
						end
					end

					y = 0
					z = 0
					for A = 1, 12 do
						local B = w[A] or Color3.new(0, 0, 0)
						local C = x:Clone()
						C.BackgroundColor3 = B
						C.Position = UDim2.new(0, 1 + 30 * z, 0, 20 + 23 * y)

						C.MouseButton1Click:Connect(function()
							local D = w[A] or Color3.new(0, 0, 0)
							r, s, t = D.r, D.g, D.b
							o, p, q = Color3.toHSV(D)
							updateColor()
						end)

						C.MouseButton2Click:Connect(function()
							w[A] = u
							C.BackgroundColor3 = u
						end)

						C.Parent = aG
						z = z + 1
						if z == 6 then
							y = y + 1
							z = 0
						end
					end

					aH.MouseButton1Click:Connect(function()
						av.OnSelect:Fire(u)
						ax:Close()
					end)
					aH.InputBegan:Connect(function(A)
						if A.UserInputType == Enum.UserInputType.MouseMovement then
							aH.BackgroundTransparency = 0.4
						end
					end)
					aH.InputEnded:Connect(function(A)
						if A.UserInputType == Enum.UserInputType.MouseMovement then
							aH.BackgroundTransparency = 0
						end
					end)

					aI.MouseButton1Click:Connect(function()
						av.OnCancel:Fire()
						ax:Close()
					end)
					aI.InputBegan:Connect(function(A)
						if A.UserInputType == Enum.UserInputType.MouseMovement then
							aI.BackgroundTransparency = 0.4
						end
					end)
					aI.InputEnded:Connect(function(A)
						if A.UserInputType == Enum.UserInputType.MouseMovement then
							aI.BackgroundTransparency = 0
						end
					end)

					updateColor()

					av.SetColor = function(A, B)
						r, s, t = B.r, B.g, B.b
						o, p, q = Color3.toHSV(B)
						updateColor()
					end

					av.Show = function(A)
						A.Window:Show()
					end

					return av
				end

				return { new = new }
			end)()

			ap.NumberSequenceEditor = (function()
				local function new()
					local av = setmetatable({}, {})
					av.OnSelect = ap.Signal.new()
					av.OnCancel = ap.Signal.new()
					av.OnPreview = ap.Signal.new()

					local aw = an({
						{ 1, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0, ClipsDescendants = true, Name = "Content", Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 1, -20) } },
						{ 2, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Time", Parent = { 1 }, Position = UDim2.new(0, 40, 0, 210), Size = UDim2.new(0, 60, 0, 20) } },
						{ 3, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), ClipsDescendants = true, Font = 3, Name = "Input", Parent = { 2 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 58, 0, 20), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 4, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 2 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Time", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 5, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Font = 3, Name = "Close", Parent = { 1 }, Position = UDim2.new(1, -90, 0, 210), Size = UDim2.new(0, 80, 0, 20), Text = "Close", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 6, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Font = 3, Name = "Reset", Parent = { 1 }, Position = UDim2.new(1, -180, 0, 210), Size = UDim2.new(0, 80, 0, 20), Text = "Reset", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 7, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Font = 3, Name = "Delete", Parent = { 1 }, Position = UDim2.new(0, 380, 0, 210), Size = UDim2.new(0, 80, 0, 20), Text = "Delete", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 8, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Name = "NumberLineOutlines", Parent = { 1 }, Position = UDim2.new(0, 10, 0, 20), Size = UDim2.new(1, -20, 0, 170) } },
						{ 9, "Frame", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), Name = "NumberLine", Parent = { 1 }, Position = UDim2.new(0, 10, 0, 20), Size = UDim2.new(1, -20, 0, 170) } },
						{ 10, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Value", Parent = { 1 }, Position = UDim2.new(0, 170, 0, 210), Size = UDim2.new(0, 60, 0, 20) } },
						{ 11, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 10 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Value", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 12, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), ClipsDescendants = true, Font = 3, Name = "Input", Parent = { 10 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 58, 0, 20), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 13, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Envelope", Parent = { 1 }, Position = UDim2.new(0, 300, 0, 210), Size = UDim2.new(0, 60, 0, 20) } },
						{ 14, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), ClipsDescendants = true, Font = 3, Name = "Input", Parent = { 13 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 58, 0, 20), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 15, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 13 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Envelope", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
					})
					local ax = ap.Window.new()
					ax.Resizable = false
					ax:Resize(680, 265)
					ax:SetTitle("NumberSequence Editor")
					av.Window = ax
					av.Gui = ax.Gui
					for ay, az in pairs(aw:GetChildren()) do
						az.Parent = ax.GuiElems.Content
					end
					local ay = ax.Gui
					local az = ay.Main
					local aA = az.TopBar
					local aB = az.Content
					local aD = aB.NumberLine
					local aE = aB.NumberLineOutlines
					local aF = aB.Time.Input
					local aG = aB.Value.Input
					local aH = aB.Envelope.Input
					local aI = aB.Delete
					local aJ = aB.Reset
					local aK = aB.Close
					local aL = aA.Close

					local aM = { { 1, 0, 3 }, { 8, 0.05, 1 }, { 5, 0.6, 2 }, { 4, 0.7, 4 }, { 6, 1, 4 } }
					local aN = {}
					local aO = {}
					local aQ = aM[1]
					local aR = aM[#aM]
					local l
					local m
					local n

					local o = i(game:GetService("UserInputService"))
					local p = i(game:GetService("Players")).LocalPlayer:GetMouse()

					for q = 2, 10 do
						local r = Instance.new("Frame")
						r.BackgroundTransparency = 0.5
						r.BackgroundColor3 = Color3.new(0.3764705882352941, 0.3764705882352941, 0.3764705882352941)
						r.BorderSizePixel = 0
						r.Size = UDim2.new(0, 1, 1, 0)
						r.Position = UDim2.new((q - 1) / 10, 0, 0, 0)
						r.Parent = aE
					end

					for q = 2, 4 do
						local r = Instance.new("Frame")
						r.BackgroundTransparency = 0.5
						r.BackgroundColor3 = Color3.new(0.3764705882352941, 0.3764705882352941, 0.3764705882352941)
						r.BorderSizePixel = 0
						r.Size = UDim2.new(1, 0, 0, 1)
						r.Position = UDim2.new(0, 0, (q - 1) / 4, 0)
						r.Parent = aE
					end

					local q = Instance.new("Frame")
					q.BackgroundColor3 = Color3.new(0, 0, 0)
					q.BorderSizePixel = 0
					q.Size = UDim2.new(0, 1, 0, 1)

					local r = Instance.new("Frame")
					r.BackgroundColor3 = Color3.new(0, 0, 0)
					r.BorderSizePixel = 0
					r.Size = UDim2.new(0, 1, 0, 0)

					for s = 1, aD.AbsoluteSize.X do
						local t = r:Clone()
						aO[s] = t
						t.Name = "E" .. tostring(s)
						t.BackgroundTransparency = 0.5
						t.BackgroundColor3 = Color3.new(0.7803921568627451, 0.17254901960784313, 0.10980392156862745)
						t.Position = UDim2.new(0, s - 1, 0, 0)
						t.Parent = aD
					end

					for s = 1, aD.AbsoluteSize.X do
						local t = r:Clone()
						aN[s] = t
						t.Name = tostring(s)
						t.Position = UDim2.new(0, s - 1, 0, 0)
						t.Parent = aD
					end

					local s = Instance.new("Frame")
					s.BackgroundTransparency = 1
					s.BackgroundColor3 = Color3.new(0, 0, 0)
					s.BorderSizePixel = 0
					s.Size = UDim2.new(0, 7, 0, 20)
					s.Visible = false
					s.ZIndex = 2
					local t = Instance.new("Frame", s)
					t.Name = "Line"
					t.BackgroundColor3 = Color3.new(0, 0, 0)
					t.BorderSizePixel = 0
					t.Position = UDim2.new(0, 3, 0, 0)
					t.Size = UDim2.new(0, 1, 0, 20)
					t.ZIndex = 2

					local u, v = s:Clone(), s:Clone()
					u.Parent = aD
					v.Parent = aD

					local function buildSequence()
						local w = {}
						for x, y in pairs(aM) do
							table.insert(w, NumberSequenceKeypoint.new(y[2], y[1], y[3]))
						end
						av.Sequence = NumberSequence.new(w)
						av.OnSelect:Fire(av.Sequence)
					end

					local function round(w, x)
						local y = 10 ^ x
						return math.floor(w * y + 0.5) / y
					end

					local function updateInputs(w)
						if w then
							m = w
							local x, y, z = w[2], w[1], w[3]
							aF.Text = round(x, (x < 0.01 and 5) or (x < 0.1 and 4) or 3)
							aG.Text = round(y, (y < 0.01 and 5) or (y < 0.1 and 4) or (y < 1 and 3) or 2)
							aH.Text = round(z, (z < 0.01 and 5) or (z < 0.1 and 4) or (y < 1 and 3) or 2)

							local A = aD.AbsoluteSize.Y * (w[3] / 10)
							u.Position = UDim2.new(0, w[4].Position.X.Offset - 1, 0, w[4].Position.Y.Offset - A - 17)
							u.Visible = true
							v.Position = UDim2.new(0, w[4].Position.X.Offset - 1, 0, w[4].Position.Y.Offset + A + 2)
							v.Visible = true
						end
					end

					u.InputBegan:Connect(function(w)
						if w.UserInputType ~= Enum.UserInputType.MouseButton1 or not m or ap.CheckMouseInGui(m[4].Select) then
							return
						end
						local x, y
						local z = aD.AbsoluteSize.Y

						local A = math.abs(u.AbsolutePosition.Y - p.Y)

						u.Line.Position = UDim2.new(0, 2, 0, 0)
						u.Line.Size = UDim2.new(0, 3, 0, 20)

						y = o.InputEnded:Connect(function(B)
							if B.UserInputType ~= Enum.UserInputType.MouseButton1 then
								return
							end
							x:Disconnect()
							y:Disconnect()
							u.Line.Position = UDim2.new(0, 3, 0, 0)
							u.Line.Size = UDim2.new(0, 1, 0, 20)
						end)

						x = o.InputChanged:Connect(function(B)
							if B.UserInputType == Enum.UserInputType.MouseMovement then
								local C = (m[4].AbsolutePosition.Y + 2) - (p.Y - A) - 19
								local D = 10 * (math.max(C, 0) / z)
								local E = math.min(m[1], 10 - m[1])
								m[3] = math.min(D, E)
								av:Redraw()
								buildSequence()
								updateInputs(m)
							end
						end)
					end)

					v.InputBegan:Connect(function(w)
						if w.UserInputType ~= Enum.UserInputType.MouseButton1 or not m or ap.CheckMouseInGui(m[4].Select) then
							return
						end
						local x, y
						local z = aD.AbsoluteSize.Y

						local A = math.abs(v.AbsolutePosition.Y - p.Y)

						v.Line.Position = UDim2.new(0, 2, 0, 0)
						v.Line.Size = UDim2.new(0, 3, 0, 20)

						y = o.InputEnded:Connect(function(B)
							if B.UserInputType ~= Enum.UserInputType.MouseButton1 then
								return
							end
							x:Disconnect()
							y:Disconnect()
							v.Line.Position = UDim2.new(0, 3, 0, 0)
							v.Line.Size = UDim2.new(0, 1, 0, 20)
						end)

						x = o.InputChanged:Connect(function(B)
							if B.UserInputType == Enum.UserInputType.MouseMovement then
								local C = (p.Y + (20 - A)) - (m[4].AbsolutePosition.Y + 2) - 19
								local D = 10 * (math.max(C, 0) / z)
								local E = math.min(m[1], 10 - m[1])
								m[3] = math.min(D, E)
								av:Redraw()
								buildSequence()
								updateInputs(m)
							end
						end)
					end)

					local function placePoint(w)
						local x = Instance.new("Frame")
						x.Name = "Point"
						x.BorderSizePixel = 0
						x.Size = UDim2.new(0, 5, 0, 5)
						x.Position = UDim2.new(0, math.floor((aD.AbsoluteSize.X - 1) * w[2]) - 2, 0, aD.AbsoluteSize.Y * (10 - w[1]) / 10 - 2)
						x.BackgroundColor3 = Color3.new(0, 0, 0)

						local y = Instance.new("Frame")
						y.Name = "Select"
						y.BackgroundTransparency = 1
						y.BackgroundColor3 = Color3.new(0.7803921568627451, 0.17254901960784313, 0.10980392156862745)
						y.Position = UDim2.new(0, -2, 0, -2)
						y.Size = UDim2.new(0, 9, 0, 9)
						y.Parent = x

						x.Parent = aD

						y.InputBegan:Connect(function(z)
							if z.UserInputType == Enum.UserInputType.MouseMovement then
								for A, B in pairs(aM) do
									B[4].Select.BackgroundTransparency = 1
								end
								y.BackgroundTransparency = 0
								updateInputs(w)
							end
							if z.UserInputType == Enum.UserInputType.MouseButton1 and not l then
								m = w
								local A, B
								l = true
								y.BackgroundColor3 = Color3.new(0.9764705882352941, 0.7490196078431373, 0.23137254901960785)

								local C = w[3]

								B = o.InputEnded:Connect(function(D)
									if D.UserInputType ~= Enum.UserInputType.MouseButton1 then
										return
									end
									A:Disconnect()
									B:Disconnect()
									l = nil
									y.BackgroundColor3 = Color3.new(0.7803921568627451, 0.17254901960784313, 0.10980392156862745)
								end)

								A = o.InputChanged:Connect(function(D)
									if D.UserInputType == Enum.UserInputType.MouseMovement then
										local E = aD.AbsoluteSize.X - 1
										local F = p.X - aD.AbsolutePosition.X
										if F < 0 then
											F = 0
										end
										if F > E then
											F = E
										end
										local G = aD.AbsoluteSize.Y - 1
										local H = p.Y - aD.AbsolutePosition.Y
										if H < 0 then
											H = 0
										end
										if H > G then
											H = G
										end
										if w ~= aQ and w ~= aR then
											w[2] = F / E
										end
										w[1] = 10 - (H / G) * 10
										local I = math.min(w[1], 10 - w[1])
										w[3] = math.min(C, I)
										av:Redraw()
										updateInputs(w)
										for J, K in pairs(aM) do
											K[4].Select.BackgroundTransparency = 1
										end
										y.BackgroundTransparency = 0
										buildSequence()
									end
								end)
							end
						end)

						return x
					end

					local function placePoints()
						for w, x in pairs(aM) do
							x[4] = placePoint(x)
						end
					end

					local function redraw(w)
						local x = aD.AbsoluteSize
						table.sort(aM, function(y, z)
							return y[2] < z[2]
						end)
						for y, z in pairs(aM) do
							z[4].Position = UDim2.new(0, math.floor((x.X - 1) * z[2]) - 2, 0, (x.Y - 1) * (10 - z[1]) / 10 - 2)
						end
						aN[1].Size = UDim2.new(0, 1, 0, 0)
						for y = 1, #aM - 1 do
							local z = aM[y]
							local A = aM[y + 1]
							local B = A[4].Position.Y.Offset - z[4].Position.Y.Offset
							local C = A[4].Position.X.Offset - z[4].Position.X.Offset
							local D = B / C

							local E = z[3]
							local F = A[3]

							local G = math.abs(D)
							local H = 0
							local I = math.abs(A[4].Position.Y.Offset - z[4].Position.Y.Offset)

							for J = math.min(z[4].Position.X.Offset + 1, A[4].Position.X.Offset), A[4].Position.X.Offset do
								if C == 0 and B == 0 then
									return
								end
								local K = math.floor(G)
								local L = aN[J + 3]
								if L then
									if H + K > I then
										K = I - H
									end
									if math.sign(D) == -1 then
										L.Position = UDim2.new(0, J + 2, 0, z[4].Position.Y.Offset + -(H + K) + 2)
									else
										L.Position = UDim2.new(0, J + 2, 0, z[4].Position.Y.Offset + H + 2)
									end
									L.Size = UDim2.new(0, 1, 0, math.max(K, 1))
								end
								H = H + K
								G = G - K + math.abs(D)

								local M = (J - z[4].Position.X.Offset) / (A[4].Position.X.Offset - z[4].Position.X.Offset)
								local N = E + (F - E) * M
								local O = (N / 10) * x.Y

								local P = aO[J + 3]
								if P then
									P.Position = UDim2.new(0, J + 2, 0, aN[J + 3].Position.Y.Offset - math.floor(O))
									P.Size = UDim2.new(0, 1, 0, math.floor(O * 2))
								end
							end
						end
					end
					av.Redraw = redraw

					local function loadSequence(w, x)
						n = x
						for y, z in pairs(aM) do
							if z[4] then
								z[4]:Destroy()
							end
						end
						aM = {}
						for y, z in pairs(x.Keypoints) do
							local A = math.min(z.Value, 10 - z.Value)
							local B = { z.Value, z.Time, math.min(z.Envelope, A) }
							B[4] = placePoint(B)
							table.insert(aM, B)
						end
						aQ = aM[1]
						aR = aM[#aM]
						l = nil
						redraw()
						u.Visible = false
						v.Visible = false
					end
					av.SetSequence = loadSequence

					aF.FocusLost:Connect(function()
						local w = m
						local x = tonumber(aF.Text)
						if w and x and w ~= aQ and w ~= aR then
							x = math.clamp(x, 0, 1)
							w[2] = x
							redraw()
							buildSequence()
							updateInputs(w)
						end
					end)

					aG.FocusLost:Connect(function()
						local w = m
						local x = tonumber(aG.Text)
						if w and x then
							local y = w[3]
							x = math.clamp(x, 0, 10)
							w[1] = x
							local z = math.min(w[1], 10 - w[1])
							w[3] = math.min(y, z)
							redraw()
							buildSequence()
							updateInputs(w)
						end
					end)

					aH.FocusLost:Connect(function()
						local w = m
						local x = tonumber(aH.Text)
						if w and x then
							x = math.clamp(x, 0, 5)
							local y = math.min(w[1], 10 - w[1])
							w[3] = math.min(x, y)
							redraw()
							buildSequence()
							updateInputs(w)
						end
					end)

					local function buttonAnimations(w, x)
						w.InputBegan:Connect(function(y)
							if y.UserInputType == Enum.UserInputType.MouseMovement then
								w.BackgroundTransparency = (x and 0.5 or 0.4)
							end
						end)
						w.InputEnded:Connect(function(y)
							if y.UserInputType == Enum.UserInputType.MouseMovement then
								w.BackgroundTransparency = (x and 1 or 0)
							end
						end)
					end

					aD.InputBegan:Connect(function(w)
						if w.UserInputType == Enum.UserInputType.MouseButton1 and #aM < 20 then
							if ap.CheckMouseInGui(u) or ap.CheckMouseInGui(v) then
								return
							end
							for x, y in pairs(aM) do
								if ap.CheckMouseInGui(y[4].Select) then
									return
								end
							end
							local x = aD.AbsoluteSize.X - 1
							local y = p.X - aD.AbsolutePosition.X
							if y < 0 then
								y = 0
							end
							if y > x then
								y = x
							end
							local z = aD.AbsoluteSize.Y - 1
							local A = p.Y - aD.AbsolutePosition.Y
							if A < 0 then
								A = 0
							end
							if A > z then
								A = z
							end

							local B = y / x
							local C = { 10 - (A / z) * 10, B, 0 }
							C[4] = placePoint(C)
							table.insert(aM, C)
							redraw()
							buildSequence()
						end
					end)

					aI.MouseButton1Click:Connect(function()
						if m and m ~= aQ and m ~= aR then
							for w, x in pairs(aM) do
								if x == m then
									x[4]:Destroy()
									table.remove(aM, w)
									break
								end
							end
							l = nil
							redraw()
							buildSequence()
							updateInputs(aM[1])
						end
					end)

					aJ.MouseButton1Click:Connect(function()
						if n then
							av:SetSequence(n)
							buildSequence()
						end
					end)

					aK.MouseButton1Click:Connect(function()
						ax:Close()
					end)

					buttonAnimations(aI)
					buttonAnimations(aJ)
					buttonAnimations(aK)

					placePoints()
					redraw()

					av.Show = function(w)
						ax:Show()
					end

					return av
				end

				return { new = new }
			end)()

			ap.ColorSequenceEditor = (function()
				local function new()
					local av = setmetatable({}, {})
					av.OnSelect = ap.Signal.new()
					av.OnCancel = ap.Signal.new()
					av.OnPreview = ap.Signal.new()
					av.OnPickColor = ap.Signal.new()

					local aw = an({
						{ 1, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0, ClipsDescendants = true, Name = "Content", Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 1, -20) } },
						{ 2, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Name = "ColorLine", Parent = { 1 }, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 70) } },
						{ 3, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Name = "Gradient", Parent = { 2 }, Size = UDim2.new(1, 0, 1, 0) } },
						{ 4, "UIGradient", { Parent = { 3 } } },
						{ 5, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Arrows", Parent = { 1 }, Position = UDim2.new(0, 1, 0, 73), Size = UDim2.new(1, -2, 0, 16) } },
						{ 6, "Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5, BorderSizePixel = 0, Name = "Cursor", Parent = { 1 }, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0, 1, 0, 80) } },
						{ 7, "Frame", { BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204), BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979), Name = "Time", Parent = { 1 }, Position = UDim2.new(0, 40, 0, 95), Size = UDim2.new(0, 100, 0, 20) } },
						{ 8, "TextBox", { BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054), ClipsDescendants = true, Font = 3, Name = "Input", Parent = { 7 }, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(0, 98, 0, 20), Text = "0", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 0 } },
						{ 9, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 7 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Time", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 10, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), Name = "ColorBox", Parent = { 1 }, Position = UDim2.new(0, 220, 0, 95), Size = UDim2.new(0, 20, 0, 20) } },
						{ 11, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Title", Parent = { 10 }, Position = UDim2.new(0, -40, 0, 0), Size = UDim2.new(0, 34, 1, 0), Text = "Color", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14, TextXAlignment = 1 } },
						{ 12, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), BorderSizePixel = 0, Font = 3, Name = "Close", Parent = { 1 }, Position = UDim2.new(1, -90, 0, 95), Size = UDim2.new(0, 80, 0, 20), Text = "Close", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 13, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), BorderSizePixel = 0, Font = 3, Name = "Reset", Parent = { 1 }, Position = UDim2.new(1, -180, 0, 95), Size = UDim2.new(0, 80, 0, 20), Text = "Reset", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 14, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506), BorderSizePixel = 0, Font = 3, Name = "Delete", Parent = { 1 }, Position = UDim2.new(0, 280, 0, 95), Size = UDim2.new(0, 80, 0, 20), Text = "Delete", TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489), TextSize = 14 } },
						{ 15, "Frame", { BackgroundTransparency = 1, Name = "Arrow", Parent = { 1 }, Size = UDim2.new(0, 16, 0, 16), Visible = false } },
						{ 16, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 15 }, Position = UDim2.new(0, 8, 0, 3), Size = UDim2.new(0, 1, 0, 2) } },
						{ 17, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 15 }, Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 3, 0, 2) } },
						{ 18, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 15 }, Position = UDim2.new(0, 6, 0, 7), Size = UDim2.new(0, 5, 0, 2) } },
						{ 19, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 15 }, Position = UDim2.new(0, 5, 0, 9), Size = UDim2.new(0, 7, 0, 2) } },
						{ 20, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 15 }, Position = UDim2.new(0, 4, 0, 11), Size = UDim2.new(0, 9, 0, 2) } },
					})
					local ax = ap.Window.new()
					ax.Resizable = false
					ax:Resize(650, 150)
					ax:SetTitle("ColorSequence Editor")
					av.Window = ax
					av.Gui = ax.Gui
					for ay, az in pairs(aw:GetChildren()) do
						az.Parent = ax.GuiElems.Content
					end
					local ay = ax.Gui
					local az = ay.Main
					local aA = az.TopBar
					local aB = az.Content
					local aD = aB.ColorLine
					local aE = aD.Gradient.UIGradient
					local aF = aB.Arrows
					local aG = aB.Arrow
					local aH = aB.Cursor
					local aI = aB.Time.Input
					local aJ = aB.ColorBox
					local aK = aB.Delete
					local aL = aB.Reset
					local aM = aB.Close
					local aN = aA.Close

					local aO = i(game:GetService("UserInputService"))
					local aQ = i(game:GetService("Players")).LocalPlayer:GetMouse()

					local aR = { { Color3.new(1, 0, 1), 0 }, { Color3.new(0.2, 0.9, 0.2), 0.2 }, { Color3.new(0.4, 0.5, 0.9), 0.7 }, { Color3.new(0.6, 1, 1), 1 } }
					local l

					local m = aR[1]
					local n = aR[#aR]

					local o
					local p

					local q = Instance.new("Frame")
					q.BorderSizePixel = 0
					q.Size = UDim2.new(0, 1, 1, 0)

					av.Sequence = ColorSequence.new(Color3.new(1, 1, 1))
					local function buildSequence(r)
						local s = {}
						table.sort(aR, function(t, u)
							return t[2] < u[2]
						end)
						for t, u in pairs(aR) do
							table.insert(s, ColorSequenceKeypoint.new(u[2], u[1]))
						end
						av.Sequence = ColorSequence.new(s)
						if not r then
							av.OnSelect:Fire(av.Sequence)
						end
					end

					local function round(r, s)
						local t = 10 ^ s
						return math.floor(r * t + 0.5) / t
					end

					local function updateInputs(r)
						if r then
							p = r
							local s = r[2]
							aI.Text = round(s, (s < 0.01 and 5) or (s < 0.1 and 4) or 3)
							aJ.BackgroundColor3 = r[1]
						end
					end

					local function placeArrow(r, s)
						local t = aG:Clone()
						t.Position = UDim2.new(0, r - 1, 0, 0)
						t.Visible = true
						t.Parent = aF

						t.InputBegan:Connect(function(u)
							if u.UserInputType == Enum.UserInputType.MouseMovement then
								aH.Visible = true
								aH.Position = UDim2.new(0, 9 + t.Position.X.Offset, 0, 0)
							end
							if u.UserInputType == Enum.UserInputType.MouseButton1 then
								updateInputs(s)
								if s == m or s == n or o then
									return
								end

								local v, w
								o = true

								w = aO.InputEnded:Connect(function(x)
									if x.UserInputType ~= Enum.UserInputType.MouseButton1 then
										return
									end
									v:Disconnect()
									w:Disconnect()
									o = nil
									aH.Visible = false
								end)

								v = aO.InputChanged:Connect(function(x)
									if x.UserInputType == Enum.UserInputType.MouseMovement then
										local y = aD.AbsoluteSize.X - 1
										local z = aQ.X - aD.AbsolutePosition.X
										if z < 0 then
											z = 0
										end
										if z > y then
											z = y
										end
										local A = z / y
										s[2] = z / y
										updateInputs(s)
										aH.Visible = true
										aH.Position = UDim2.new(0, 9 + t.Position.X.Offset, 0, 0)
										buildSequence()
										av:Redraw()
									end
								end)
							end
						end)

						t.InputEnded:Connect(function(u)
							if u.UserInputType == Enum.UserInputType.MouseMovement then
								aH.Visible = false
							end
						end)

						return t
					end

					local function placeArrows()
						for r, s in pairs(aR) do
							s[3] = placeArrow(math.floor((aD.AbsoluteSize.X - 1) * s[2]) + 1, s)
						end
					end

					local function redraw(r)
						aE.Color = av.Sequence or ColorSequence.new(Color3.new(1, 1, 1))

						for s = 2, #aR do
							local t = aR[s]
							local u = math.floor((aD.AbsoluteSize.X - 1) * t[2]) + 1
							t[3].Position = UDim2.new(0, u, 0, 0)
						end
					end
					av.Redraw = redraw

					local function loadSequence(r, s)
						l = s
						for t, u in pairs(aR) do
							if u[3] then
								u[3]:Destroy()
							end
						end
						aR = {}
						o = nil
						for t, u in pairs(s.Keypoints) do
							local v = { u.Value, u.Time }
							v[3] = placeArrow(u.Time, v)
							table.insert(aR, v)
						end
						m = aR[1]
						n = aR[#aR]
						o = nil
						updateInputs(aR[1])
						buildSequence(true)
						redraw()
					end
					av.SetSequence = loadSequence

					local function buttonAnimations(r, s)
						r.InputBegan:Connect(function(t)
							if t.UserInputType == Enum.UserInputType.MouseMovement then
								r.BackgroundTransparency = (s and 0.5 or 0.4)
							end
						end)
						r.InputEnded:Connect(function(t)
							if t.UserInputType == Enum.UserInputType.MouseMovement then
								r.BackgroundTransparency = (s and 1 or 0)
							end
						end)
					end

					aD.InputBegan:Connect(function(r)
						if r.UserInputType == Enum.UserInputType.MouseButton1 and #aR < 20 then
							local s = aD.AbsoluteSize.X - 1
							local t = aQ.X - aD.AbsolutePosition.X
							if t < 0 then
								t = 0
							end
							if t > s then
								t = s
							end

							local u = t / s
							local v
							local w
							for x, y in pairs(aR) do
								if y[2] >= u then
									v = aR[math.max(x - 1, 1)]
									w = aR[x]
									break
								end
							end
							local x = v[1]:lerp(w[1], (u - v[2]) / (w[2] - v[2]))
							local y = { x, u }
							y[3] = placeArrow(y[2], y)
							table.insert(aR, y)
							updateInputs(y)
							buildSequence()
							redraw()
						end
					end)

					aD.InputChanged:Connect(function(r)
						if r.UserInputType == Enum.UserInputType.MouseMovement then
							local s = aD.AbsoluteSize.X - 1
							local t = aQ.X - aD.AbsolutePosition.X
							if t < 0 then
								t = 0
							end
							if t > s then
								t = s
							end
							aH.Visible = true
							aH.Position = UDim2.new(0, 10 + t, 0, 0)
						end
					end)

					aD.InputEnded:Connect(function(r)
						if r.UserInputType == Enum.UserInputType.MouseMovement then
							local s = false
							for t, u in pairs(aR) do
								if ap.CheckMouseInGui(u[3]) then
									s = u[3]
								end
							end
							aH.Visible = s and true or false
							if s then
								aH.Position = UDim2.new(0, 9 + s.Position.X.Offset, 0, 0)
							end
						end
					end)

					aI:GetPropertyChangedSignal("Text"):Connect(function()
						local r = p
						local s = tonumber(aI.Text)
						if r and s and r ~= m and r ~= n then
							s = math.clamp(s, 0, 1)
							r[2] = s
							buildSequence()
							redraw()
						end
					end)

					aJ.InputBegan:Connect(function(r)
						if r.UserInputType == Enum.UserInputType.MouseButton1 then
							local s = av.ColorPicker
							if not s then
								s = ap.ColorPicker.new()
								s.Window:SetTitle("ColorSequence Color Picker")

								s.OnSelect:Connect(function(t)
									if p then
										p[1] = t
									end
									buildSequence()
									redraw()
								end)

								av.ColorPicker = s
							end

							s.Window:ShowAndFocus()
						end
					end)

					aK.MouseButton1Click:Connect(function()
						if p and p ~= m and p ~= n then
							for r, s in pairs(aR) do
								if s == p then
									s[3]:Destroy()
									table.remove(aR, r)
									break
								end
							end
							o = nil
							updateInputs(aR[1])
							buildSequence()
							redraw()
						end
					end)

					aL.MouseButton1Click:Connect(function()
						if l then
							av:SetSequence(l)
						end
					end)

					aM.MouseButton1Click:Connect(function()
						ax:Close()
					end)

					aN.MouseButton1Click:Connect(function()
						ax:Close()
					end)

					buttonAnimations(aK)
					buttonAnimations(aL)
					buttonAnimations(aM)

					placeArrows()
					redraw()

					av.Show = function(r)
						ax:Show()
					end

					return av
				end

				return { new = new }
			end)()

			ap.ViewportTextBox = (function()
				local av = i(game:GetService("TextService"))

				local aw = {
					OffsetX = 0,
					TextBox = at,
					CursorPos = -1,
					Gui = at,
					View = at,
				}
				local ax = {}
				ax.Update = function(ay)
					local az = ay.CursorPos or -1
					local aA = ay.TextBox.Text
					if aA == "" then
						ay.TextBox.Position = UDim2.new(0, 0, 0, 0)
						return
					end
					if az == -1 then
						return
					end

					local aB = aA:sub(1, az - 1)
					local aD
					local aE = -ay.TextBox.Position.X.Offset
					local aF = aE + ay.View.AbsoluteSize.X

					local aG = av:GetTextSize(aA, ay.TextBox.TextSize, ay.TextBox.Font, Vector2.new(999999999, 100)).X
					local aH = av:GetTextSize(aB, ay.TextBox.TextSize, ay.TextBox.Font, Vector2.new(999999999, 100)).X

					if aH > aF then
						aD = math.max(-1, aH - ay.View.AbsoluteSize.X + 2)
					elseif aH < aE then
						aD = math.max(-1, aH - 2)
					elseif aG < aF then
						aD = math.max(-1, aG - ay.View.AbsoluteSize.X + 2)
					end

					if aD then
						ay.TextBox.Position = UDim2.new(0, -aD, 0, 0)
						ay.TextBox.Size = UDim2.new(1, aD, 1, 0)
					end
				end

				ax.GetText = function(ay)
					return ay.TextBox.Text
				end

				ax.SetText = function(ay, az)
					ay.TextBox.Text = az
				end

				local ay = getGuiMT(aw, ax)

				local function convert(az)
					local aA = initObj(aw, ay)

					local aB = Instance.new("Frame")
					aB.BackgroundTransparency = az.BackgroundTransparency
					aB.BackgroundColor3 = az.BackgroundColor3
					aB.BorderSizePixel = az.BorderSizePixel
					aB.BorderColor3 = az.BorderColor3
					aB.Position = az.Position
					aB.Size = az.Size
					aB.ClipsDescendants = true
					aB.Name = az.Name
					az.BackgroundTransparency = 1
					az.Position = UDim2.new(0, 0, 0, 0)
					az.Size = UDim2.new(1, 0, 1, 0)
					az.TextXAlignment = Enum.TextXAlignment.Left
					az.Name = "Input"

					aA.TextBox = az
					aA.View = aB
					aA.Gui = aB

					az.Changed:Connect(function(aD)
						if aD == "Text" or aD == "CursorPosition" or aD == "AbsoluteSize" then
							local aE = aA.TextBox.CursorPosition
							if aE ~= -1 then
								aA.CursorPos = aE
							end
							aA:Update()
						end
					end)

					aA:Update()

					aB.Parent = az.Parent
					az.Parent = aB

					return aA
				end

				local function new()
					local az = Instance.new("TextBox")
					az.Size = UDim2.new(0, 100, 0, 20)
					az.BackgroundColor3 = ad.Theme.TextBox
					az.BorderColor3 = ad.Theme.Outline3
					az.ClearTextOnFocus = false
					az.TextColor3 = ad.Theme.Text
					az.Font = Enum.Font.SourceSans
					az.TextSize = 14
					az.Text = ""
					return convert(az)
				end

				return { new = new, convert = convert }
			end)()

			ap.Label = (function()
				local av, aw = {}, {}

				local ax = getGuiMT(av, aw)

				local function new()
					local ay = Instance.new("TextLabel")
					ay.BackgroundTransparency = 1
					ay.TextXAlignment = Enum.TextXAlignment.Left
					ay.TextColor3 = ad.Theme.Text
					ay.TextTransparency = 0.1
					ay.Size = UDim2.new(0, 100, 0, 20)
					ay.Font = Enum.Font.SourceSans
					ay.TextSize = 14

					local az = setmetatable({
						Gui = ay,
					}, ax)
					return az
				end

				return { new = new }
			end)()

			ap.Frame = (function()
				local av, aw = {}, {}

				local ax = getGuiMT(av, aw)

				local function new()
					local ay = Instance.new("Frame")
					ay.BackgroundColor3 = ad.Theme.Main1
					ay.BorderColor3 = ad.Theme.Outline1
					ay.Size = UDim2.new(0, 50, 0, 50)

					local az = setmetatable({
						Gui = ay,
					}, ax)
					return az
				end

				return { new = new }
			end)()

			ap.Button = (function()
				local av = {
					Gui = at,
					Anim = at,
					Disabled = false,
					OnClick = au,
					OnDown = au,
					OnUp = au,
					AllowedButtons = { 1 },
				}
				local aw = {}
				local ax = table.find

				aw.Trigger = function(ay, az, aA)
					if not ay.Disabled and ax(ay.AllowedButtons, aA) then
						ay["On" .. az]:Fire(aA)
					end
				end

				aw.SetDisabled = function(ay, az)
					ay.Disabled = az

					if az then
						ay.Anim:Disable()
						ay.Gui.TextTransparency = 0.5
					else
						ay.Anim.Enable()
						ay.Gui.TextTransparency = 0
					end
				end

				local ay = getGuiMT(av, aw)

				local function new()
					local az = Instance.new("TextButton")
					az.AutoButtonColor = false
					az.TextColor3 = ad.Theme.Text
					az.TextTransparency = 0.1
					az.Size = UDim2.new(0, 100, 0, 20)
					az.Font = Enum.Font.SourceSans
					az.TextSize = 14
					az.BackgroundColor3 = ad.Theme.Button
					az.BorderColor3 = ad.Theme.Outline2

					local aA = initObj(av, ay)
					aA.Gui = az
					aA.Anim = ap.ButtonAnim(az, { Mode = 2, StartColor = ad.Theme.Button, HoverColor = ad.Theme.ButtonHover, PressColor = ad.Theme.ButtonPress, OutlineColor = ad.Theme.Outline2 })

					az.MouseButton1Click:Connect(function()
						aA:Trigger("Click", 1)
					end)
					az.MouseButton1Down:Connect(function()
						aA:Trigger("Down", 1)
					end)
					az.MouseButton1Up:Connect(function()
						aA:Trigger("Up", 1)
					end)

					az.MouseButton2Click:Connect(function()
						aA:Trigger("Click", 2)
					end)
					az.MouseButton2Down:Connect(function()
						aA:Trigger("Down", 2)
					end)
					az.MouseButton2Up:Connect(function()
						aA:Trigger("Up", 2)
					end)

					return aA
				end

				return { new = new }
			end)()

			ap.DropDown = (function()
				local av = {
					Gui = at,
					Anim = at,
					Context = at,
					Selected = at,
					Disabled = false,
					CanBeEmpty = true,
					Options = {},
					GuiElems = {},
					OnSelect = au,
				}
				local aw = {}

				aw.Update = function(ax)
					local ay = ax.Options

					if #ay > 0 then
						if not ax.Selected then
							if not ax.CanBeEmpty then
								ax.Selected = ay[1]
								ax.GuiElems.Label.Text = ay[1]
							else
								ax.GuiElems.Label.Text = "- Select -"
							end
						else
							ax.GuiElems.Label.Text = ax.Selected
						end
					else
						ax.GuiElems.Label.Text = "- Select -"
					end
				end

				aw.ShowOptions = function(ax)
					local ay = ax.Context

					ay.Width = ax.Gui.AbsoluteSize.X
					ay.ReverseYOffset = ax.Gui.AbsoluteSize.Y
					ay:Show(ax.Gui.AbsolutePosition.X, ax.Gui.AbsolutePosition.Y + ay.ReverseYOffset)
				end

				aw.SetOptions = function(ax, ay)
					ax.Options = ay

					local az = ax.Context
					local aA = ax.Options
					az:Clear()

					local aB = function(aB)
						ax.Selected = aB
						ax.OnSelect:Fire(aB)
						ax:Update()
					end

					if ax.CanBeEmpty then
						az:Add({
							Name = "- Select -",
							OnClick = function()
								ax.Selected = nil
								ax.OnSelect:Fire(nil)
								ax:Update()
							end,
						})
					end

					for aD = 1, #aA do
						az:Add({ Name = aA[aD], OnClick = aB })
					end

					ax:Update()
				end

				aw.SetSelected = function(ax, ay)
					ax.Selected = type(ay) == "number" and ax.Options[ay] or ay
					ax:Update()
				end

				local ax = getGuiMT(av, aw)

				local function new()
					local ay = Instance.new("TextButton")
					ay.AutoButtonColor = false
					ay.Text = ""
					ay.Size = UDim2.new(0, 100, 0, 20)
					ay.BackgroundColor3 = ad.Theme.TextBox
					ay.BorderColor3 = ad.Theme.Outline3

					local az = ap.Label.new()
					az.Position = UDim2.new(0, 2, 0, 0)
					az.Size = UDim2.new(1, -22, 1, 0)
					az.TextTruncate = Enum.TextTruncate.AtEnd
					az.Parent = ay
					local aA = an({
						{ 1, "Frame", { BackgroundTransparency = 1, Name = "EnumArrow", Position = UDim2.new(1, -16, 0, 2), Size = UDim2.new(0, 16, 0, 16) } },
						{ 2, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(0, 8, 0, 9), Size = UDim2.new(0, 1, 0, 1) } },
						{ 3, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(0, 7, 0, 8), Size = UDim2.new(0, 3, 0, 1) } },
						{ 4, "Frame", { BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025), BorderSizePixel = 0, Parent = { 1 }, Position = UDim2.new(0, 6, 0, 7), Size = UDim2.new(0, 5, 0, 1) } },
					})
					aA.Parent = ay

					local aB = initObj(av, ax)
					aB.Gui = ay
					aB.Anim = ap.ButtonAnim(ay, { Mode = 2, StartColor = ad.Theme.TextBox, LerpTo = ad.Theme.Button, LerpDelta = 0.15 })
					aB.Context = ap.ContextMenu.new()
					aB.Context.Iconless = true
					aB.Context.MaxHeight = 200
					aB.Selected = nil
					aB.GuiElems = { Label = az }
					ay.MouseButton1Down:Connect(function()
						aB:ShowOptions()
					end)
					aB:Update()
					return aB
				end

				return { new = new }
			end)()

			ap.ClickSystem = (function()
				local av = {
					LastItem = at,
					OnDown = au,
					OnRelease = au,
					AllowedButtons = { 1 },
					Combo = 0,
					MaxCombo = 2,
					ComboTime = 0.5,
					Items = {},
					ItemCons = {},
					ClickId = -1,
					LastButton = "",
				}
				local aw = {}

				aw.Trigger = function(ax, ay, az)
					if table.find(ax.AllowedButtons, az) then
						if ax.LastButton ~= az or ax.LastItem ~= ay or ax.Combo == ax.MaxCombo or tick() - ax.ClickId > ax.ComboTime then
							ax.Combo = 0
							ax.LastButton = az
							ax.LastItem = ay
						end
						ax.Combo = ax.Combo + 1
						ax.ClickId = tick()

						local aA
						aA = al.UserInputService.InputEnded:Connect(function(aB)
							if aB.UserInputType == Enum.UserInputType["MouseButton" .. az] then
								aA:Disconnect()
								if ap.CheckMouseInGui(ay) and ax.LastButton == az and ax.LastItem == ay then
									ax.OnRelease:Fire(ay, ax.Combo, az)
								end
							end
						end)

						ax.OnDown:Fire(ay, ax.Combo, az)
					end
				end

				aw.Add = function(ax, ay)
					if table.find(ax.Items, ay) then
						return
					end

					local az = {}
					az[1] = ay.MouseButton1Down:Connect(function()
						ax:Trigger(ay, 1)
					end)
					az[2] = ay.MouseButton2Down:Connect(function()
						ax:Trigger(ay, 2)
					end)

					ax.ItemCons[ay] = az
					ax.Items[#ax.Items + 1] = ay
				end

				aw.Remove = function(ax, ay)
					local az = table.find(ax.Items, ay)
					if not az then
						return
					end

					for aA, aB in pairs(ax.ItemCons[ay]) do
						aB:Disconnect()
					end
					ax.ItemCons[ay] = nil
					table.remove(ax.Items, az)
				end

				local ax = { __index = aw }

				local function new()
					local ay = initObj(av, ax)

					return ay
				end

				return { new = new }
			end)()

			return ap
		end

		return { InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main }
	end,
}

local ab, ac

DefaultSettings = (function()
	local ad = Color3.fromRGB
	return {
		Explorer = {
			_Recurse = true,
			Sorting = true,
			TeleportToOffset = Vector3.new(0, 0, 0),
			ClickToRename = true,
			AutoUpdateSearch = true,
			AutoUpdateMode = 0,
			PartSelectionBox = true,
			GuiSelectionBox = true,
			CopyPathUseGetChildren = true,
		},
		Properties = {
			_Recurse = true,
			MaxConflictCheck = 50,
			ShowDeprecated = false,
			ShowHidden = false,
			ClearOnFocus = false,
			LoadstringInput = true,
			NumberRounding = 3,
			ShowAttributes = false,
			MaxAttributes = 50,
			ScaleType = 1,
		},
		Theme = {
			_Recurse = true,
			Main1 = ad(52, 52, 52),
			Main2 = ad(45, 45, 45),
			Outline1 = ad(33, 33, 33),
			Outline2 = ad(55, 55, 55),
			Outline3 = ad(30, 30, 30),
			TextBox = ad(38, 38, 38),
			Menu = ad(32, 32, 32),
			ListSelection = ad(11, 90, 175),
			Button = ad(60, 60, 60),
			ButtonHover = ad(68, 68, 68),
			ButtonPress = ad(40, 40, 40),
			Highlight = ad(75, 75, 75),
			Text = ad(255, 255, 255),
			PlaceholderText = ad(100, 100, 100),
			Important = ad(255, 0, 0),
			ExplorerIconMap = "",
			MiscIconMap = "",
			Syntax = {
				Text = ad(204, 204, 204),
				Background = ad(36, 36, 36),
				Selection = ad(255, 255, 255),
				SelectionBack = ad(11, 90, 175),
				Operator = ad(204, 204, 204),
				Number = ad(255, 198, 0),
				String = ad(173, 241, 149),
				Comment = ad(102, 102, 102),
				Keyword = ad(248, 109, 124),
				Error = ad(255, 0, 0),
				FindBackground = ad(141, 118, 0),
				MatchingWord = ad(85, 85, 85),
				BuiltIn = ad(132, 214, 247),
				CurrentLine = ad(45, 50, 65),
				LocalMethod = ad(253, 251, 172),
				LocalProperty = ad(97, 161, 241),
				Nil = ad(255, 198, 0),
				Bool = ad(255, 198, 0),
				Function = ad(248, 109, 124),
				Local = ad(248, 109, 124),
				Self = ad(248, 109, 124),
				FunctionName = ad(253, 251, 172),
				Bracket = ad(204, 204, 204),
			},
		},
	}
end)()

local ad = {}
local ae = {}
local af = {}
local ag = setmetatable({}, {
	__index = function(ag, ah)
		local ai = i(game:GetService(ah))
		ag[ah] = ai
		return ai
	end,
})
local ah = ag.Players.LocalPlayer or ag.Players.PlayerAdded:wait()

local ai = function(ai)
	local aj = {}
	for ak, al in pairs(ai) do
		aj[al[1]] = Instance.new(al[2])
	end

	for ak, al in pairs(ai) do
		for am, an in pairs(al[3]) do
			if type(an) == "table" then
				aj[al[1]][am] = aj[an[1]]
			else
				aj[al[1]][am] = an
			end
		end
	end

	return aj[1]
end

local aj = function(aj, ak)
	local al = Instance.new(aj)
	for am, an in next, ak do
		al[am] = an
	end
	return al
end

Main = (function()
	local ak = {}

	ak.ModuleList = { "Explorer", "Properties", "ScriptViewer" }
	ak.Elevated = false
	ak.MissingEnv = {}
	ak.Version = ""
	ak.Mouse = ah:GetMouse()
	ak.AppControls = {}
	ak.Apps = ae
	ak.MenuApps = {}

	ak.DisplayOrders = {
		SideWindow = 8,
		Window = 10,
		Menu = 100000,
		Core = 101000,
	}

	ak.GetInitDeps = function()
		return {
			Main = ak,
			Lib = Lib,
			Apps = ae,
			Settings = ad,

			API = ab,
			RMD = ac,
			env = af,
			service = ag,
			plr = ah,
			create = ai,
			createSimple = aj,
		}
	end

	ak.Error = function(al)
		if rconsoleprint then
			rconsoleprint("DEX ERROR: " .. tostring(al) .. "\n")
			wait(9e9)
		else
			error(al)
		end
	end

	ak.LoadModule = function(al)
		if ak.Elevated then
			local am

			if aa then
				am = aa[al]()

				if not am then
					ak.Error("Missing Embedded Module: " .. al)
				end
			end

			ak.AppControls[al] = am
			am.InitDeps(ak.GetInitDeps())

			local an = am.Main()
			ae[al] = an
			return an
		else
			local am = script:WaitForChild("Modules"):WaitForChild(al, 2)
			if not am then
				ak.Error("CANNOT FIND MODULE " .. al)
			end

			local an = require(am)
			ak.AppControls[al] = an
			an.InitDeps(ak.GetInitDeps())

			local ao = an.Main()
			ae[al] = ao
			return ao
		end
	end

	ak.LoadModules = function()
		for al, am in pairs(ak.ModuleList) do
			local an, ao = pcall(ak.LoadModule, am)
			if not an then
				ak.Error("FAILED LOADING " + am + " CAUSE " + ao)
			end
		end

		Explorer = ae.Explorer
		Properties = ae.Properties
		ScriptViewer = ae.ScriptViewer
		Notebook = ae.Notebook
		local al = {
			Explorer = Explorer,
			Properties = Properties,
			ScriptViewer = ScriptViewer,
			Notebook = Notebook,
		}

		ak.AppControls.Lib.InitAfterMain(al)
		for am, an in pairs(ak.ModuleList) do
			local ao = ak.AppControls[an]
			if ao then
				ao.InitAfterMain(al)
			end
		end
	end

	ak.InitEnv = function()
		setmetatable(af, {
			__newindex = function(al, am, an)
				if not an then
					ak.MissingEnv[#ak.MissingEnv + 1] = am
					return
				end
				rawset(al, am, an)
			end,
		})

		af.readfile = readfile
		af.writefile = writefile
		af.appendfile = appendfile
		af.makefolder = makefolder
		af.listfiles = listfiles
		af.loadfile = loadfile
		af.movefileas = movefileas
		af.saveinstance = saveinstance

		af.getupvalues = (debug and debug.getupvalues) or getupvalues or getupvals
		af.getconstants = (debug and debug.getconstants) or getconstants or getconsts
		af.getinfo = (debug and (debug.getinfo or debug.info)) or getinfo
		af.islclosure = islclosure or is_l_closure or is_lclosure
		af.checkcaller = checkcaller

		af.getgc = getgc or get_gc_objects
		af.base64encode = crypt and crypt.base64 and crypt.base64.encode
		af.getscriptbytecode = a

		af.request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or c
		af.decompile = decompile or (af.getscriptbytecode and af.request and af.base64encode and function(al)
			local am, an = pcall(af.getscriptbytecode, al)
			if not am then
				return "failed to get bytecode " .. tostring(an)
			end

			local ao = af.request({
				Url = "https://unluau.lonegladiator.dev/unluau/decompile",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = ag.HttpService:JSONEncode({
					version = 5,
					bytecode = af.base64encode(an),
				}),
			})

			local ap = ag.HttpService:JSONDecode(ao.Body)
			if ap.status ~= "ok" then
				return "decompilation failed: " .. tostring(ap.status)
			end

			return ap.output
		end)
		af.protectgui = protect_gui or (syn and syn.protect_gui)
		af.gethui = gethui or get_hidden_gui
		af.setclipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
		af.getnilinstances = getnilinstances or get_nil_instances
		af.getloadedmodules = getloadedmodules

		ak.GuiHolder = ak.Elevated and ag.CoreGui or ah:FindFirstChildWhichIsA("PlayerGui")

		setmetatable(af, nil)
	end

	ak.LoadSettings = function()
		local al, am = pcall(af.readfile or error, "DexSettings.json")
		if al and am and am ~= "" then
			local an, ao = ag.HttpService:JSONDecode(am)
			if an and ao then
				for ap, aq in next, ao do
				end
			end
		else
			ak.ResetSettings()
		end
	end

	ak.ResetSettings = function()
		local function recur(al, am)
			for an, ao in pairs(al) do
				if type(ao) == "table" and ao._Recurse then
					if type(am[an]) ~= "table" then
						am[an] = {}
					end
					recur(ao, am[an])
				else
					am[an] = ao
				end
			end
			return am
		end
		recur(DefaultSettings, ad)
	end

	ak.FetchAPI = function()
		local al, am
		if ak.Elevated then
			if ak.LocalDepsUpToDate() then
				local an = Lib.ReadFile("dex/rbx_api.dat")
				if an then
					am = an
				else
					ak.DepsVersionData[1] = ""
				end
			end
			am = am or game:HttpGet("http://setup.roblox.com/" .. ak.RobloxVersion .. "-API-Dump.json")
		else
			if script:FindFirstChild("API") then
				am = require(script.API)
			else
				error("NO API EXISTS")
			end
		end
		ak.RawAPI = am
		al = ag.HttpService:JSONDecode(am)

		local an, ao = {}, {}
		local ap, aq = {}, {}

		local function insertAbove(as, at, au)
			local av = table.find(as, at)
			if not av then
				return
			end
			table.remove(as, av)

			local aw = table.find(as, au)
			if not aw then
				return
			end
			table.insert(as, aw, at)
		end

		for as, at in pairs(al.Classes) do
			local au = {}
			au.Name = at.Name
			au.Superclass = at.Superclass
			au.Properties = {}
			au.Functions = {}
			au.Events = {}
			au.Callbacks = {}
			au.Tags = {}

			if at.Tags then
				for av, aw in pairs(at.Tags) do
					au.Tags[aw] = true
				end
			end
			for av, aw in pairs(at.Members) do
				local ax = {}
				ax.Name = aw.Name
				ax.Class = at.Name
				ax.Security = aw.Security
				ax.Tags = {}
				if aw.Tags then
					for ay, az in pairs(aw.Tags) do
						ax.Tags[az] = true
					end
				end

				local ay = aw.MemberType
				if ay == "Property" then
					local az = aw.Category or "Other"
					az = az:match("^%s*(.-)%s*$")
					if not aq[az] then
						ap[#ap + 1] = az
						aq[az] = true
					end
					ax.ValueType = aw.ValueType
					ax.Category = az
					ax.Serialization = aw.Serialization
					table.insert(au.Properties, ax)
				elseif ay == "Function" then
					ax.Parameters = {}
					ax.ReturnType = aw.ReturnType.Name
					for az, aA in pairs(aw.Parameters) do
						table.insert(ax.Parameters, { Name = aA.Name, Type = aA.Type.Name })
					end
					table.insert(au.Functions, ax)
				elseif ay == "Event" then
					ax.Parameters = {}
					for az, aA in pairs(aw.Parameters) do
						table.insert(ax.Parameters, { Name = aA.Name, Type = aA.Type.Name })
					end
					table.insert(au.Events, ax)
				end
			end

			an[at.Name] = au
		end

		for as, at in pairs(an) do
			at.Superclass = an[at.Superclass]
		end

		for as, at in pairs(al.Enums) do
			local au = {}
			au.Name = at.Name
			au.Items = {}
			au.Tags = {}

			if at.Tags then
				for av, aw in pairs(at.Tags) do
					au.Tags[aw] = true
				end
			end
			for av, aw in pairs(at.Items) do
				local ax = {}
				ax.Name = aw.Name
				ax.Value = aw.Value
				table.insert(au.Items, ax)
			end

			ao[at.Name] = au
		end

		local function getMember(as, at)
			if not an[as] or not an[as][at] then
				return
			end
			local au = {}

			local av = an[as]
			while av do
				for aw, ax in pairs(av[at]) do
					au[#au + 1] = ax
				end
				av = av.Superclass
			end

			table.sort(au, function(aw, ax)
				return aw.Name < ax.Name
			end)
			return au
		end

		insertAbove(ap, "Behavior", "Tuning")
		insertAbove(ap, "Appearance", "Data")
		insertAbove(ap, "Attachments", "Axes")
		insertAbove(ap, "Cylinder", "Slider")
		insertAbove(ap, "Localization", "Jump Settings")
		insertAbove(ap, "Surface", "Motion")
		insertAbove(ap, "Surface Inputs", "Surface")
		insertAbove(ap, "Part", "Surface Inputs")
		insertAbove(ap, "Assembly", "Surface Inputs")
		insertAbove(ap, "Character", "Controls")
		ap[#ap + 1] = "Unscriptable"
		ap[#ap + 1] = "Attributes"

		local as = {}
		for at = 1, #ap do
			as[ap[at]] = at
		end

		return {
			Classes = an,
			Enums = ao,
			CategoryOrder = as,
			GetMember = getMember,
		}
	end

	ak.FetchRMD = function()
		local al
		if ak.Elevated then
			if ak.LocalDepsUpToDate() then
				local am = Lib.ReadFile("dex/rbx_rmd.dat")
				if am then
					al = am
				else
					ak.DepsVersionData[1] = ""
				end
			end
			al = al or game:HttpGet("https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml")
		else
			if script:FindFirstChild("RMD") then
				al = require(script.RMD)
			else
				error("NO RMD EXISTS")
			end
		end
		ak.RawRMD = al
		local am = Lib.ParseXML(al)
		local an = am.children[1].children[1].children
		local ao = am.children[1].children[2].children
		local ap = {}

		local aq, as = {}, {}
		for at, au in pairs(an) do
			local av = ""
			for aw, ax in pairs(au.children) do
				if ax.tag == "Properties" then
					local ay = { Properties = {}, Functions = {} }
					local az = ax.children
					for aA, aB in pairs(az) do
						local aD = aB.attrs.name
						aD = aD:sub(1, 1):upper() .. aD:sub(2)
						ay[aD] = aB.children[1].text
					end
					av = ay.Name
					aq[av] = ay
				elseif ax.attrs.class == "ReflectionMetadataProperties" then
					local ay = ax.children
					for az, aA in pairs(ay) do
						if aA.attrs.class == "ReflectionMetadataMember" then
							local aB = {}
							if aA.children[1].tag == "Properties" then
								local aD = aA.children[1].children
								for aE, aF in pairs(aD) do
									if aF.attrs then
										local aG = aF.attrs.name
										aG = aG:sub(1, 1):upper() .. aG:sub(2)
										aB[aG] = aF.children[1].text
									end
								end
								if aB.PropertyOrder then
									local aE = ap[av]
									if not aE then
										aE = {}
										ap[av] = aE
									end
									aE[aB.Name] = tonumber(aB.PropertyOrder)
								end
								aq[av].Properties[aB.Name] = aB
							end
						end
					end
				elseif ax.attrs.class == "ReflectionMetadataFunctions" then
					local ay = ax.children
					for az, aA in pairs(ay) do
						if aA.attrs.class == "ReflectionMetadataMember" then
							local aB = {}
							if aA.children[1].tag == "Properties" then
								local aD = aA.children[1].children
								for aE, aF in pairs(aD) do
									if aF.attrs then
										local aG = aF.attrs.name
										aG = aG:sub(1, 1):upper() .. aG:sub(2)
										aB[aG] = aF.children[1].text
									end
								end
								aq[av].Functions[aB.Name] = aB
							end
						end
					end
				end
			end
		end

		for at, au in pairs(ao) do
			local av = ""
			for aw, ax in pairs(au.children) do
				if ax.tag == "Properties" then
					local ay = { Items = {} }
					local az = ax.children
					for aA, aB in pairs(az) do
						local aD = aB.attrs.name
						aD = aD:sub(1, 1):upper() .. aD:sub(2)
						ay[aD] = aB.children[1].text
					end
					av = ay.Name
					as[av] = ay
				elseif ax.attrs.class == "ReflectionMetadataEnumItem" then
					local ay = {}
					if ax.children[1].tag == "Properties" then
						local az = ax.children[1].children
						for aA, aB in pairs(az) do
							local aD = aB.attrs.name
							aD = aD:sub(1, 1):upper() .. aD:sub(2)
							ay[aD] = aB.children[1].text
						end
						as[av].Items[ay.Name] = ay
					end
				end
			end
		end

		return { Classes = aq, Enums = as, PropertyOrders = ap }
	end

	ak.ShowGui = function(al)
		if af.gethui then
			al.Parent = af.gethui()
		elseif af.protectgui then
			af.protectgui(al)
			al.Parent = ak.GuiHolder
		else
			al.Parent = ak.GuiHolder
		end
	end

	ak.CreateIntro = function(al)
		local am = ai({
			{ 1, "ScreenGui", { Name = "Intro" } },
			{ 2, "Frame", { Active = true, BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "Main", Parent = { 1 }, Position = UDim2.new(0.5, -175, 0.5, -100), Size = UDim2.new(0, 350, 0, 200) } },
			{ 3, "Frame", { BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0, ClipsDescendants = true, Name = "Holder", Parent = { 2 }, Size = UDim2.new(1, 0, 1, 0) } },
			{ 4, "UIGradient", { Parent = { 3 }, Rotation = 30, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0) }) } },
			{ 5, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 4, Name = "Title", Parent = { 3 }, Position = UDim2.new(0, -190, 0, 15), Size = UDim2.new(0, 100, 0, 50), Text = "Dex", TextColor3 = Color3.new(1, 1, 1), TextSize = 50, TextTransparency = 1 } },
			{ 6, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Desc", Parent = { 3 }, Position = UDim2.new(0, -230, 0, 60), Size = UDim2.new(0, 180, 0, 25), Text = "Ultimate Debugging Suite", TextColor3 = Color3.new(1, 1, 1), TextSize = 18, TextTransparency = 1 } },
			{ 7, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "StatusText", Parent = { 3 }, Position = UDim2.new(0, 20, 0, 110), Size = UDim2.new(0, 180, 0, 25), Text = "Fetching API", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 1 } },
			{ 8, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "ProgressBar", Parent = { 3 }, Position = UDim2.new(0, 110, 0, 145), Size = UDim2.new(0, 0, 0, 4) } },
			{ 9, "Frame", { BackgroundColor3 = Color3.new(0.2392156869173, 0.56078433990479, 0.86274510622025), BorderSizePixel = 0, Name = "Bar", Parent = { 8 }, Size = UDim2.new(0, 0, 1, 0) } },
			{ 10, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://2764171053", ImageColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), Parent = { 8 }, ScaleType = 1, Size = UDim2.new(1, 0, 1, 0), SliceCenter = Rect.new(2, 2, 254, 254) } },
			{ 11, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Creator", Parent = { 2 }, Position = UDim2.new(1, -110, 1, -20), Size = UDim2.new(0, 105, 0, 20), Text = "Developed by Androssy", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 1 } },
			{ 12, "UIGradient", { Parent = { 11 }, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0) }) } },
			{ 13, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Version", Parent = { 2 }, Position = UDim2.new(1, -110, 1, -35), Size = UDim2.new(0, 105, 0, 20), Text = ak.Version, TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = 1 } },
			{ 14, "UIGradient", { Parent = { 13 }, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0) }) } },
			{ 15, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = "rbxassetid://115413171231136", Name = "Outlines", Parent = { 2 }, Position = UDim2.new(0, -5, 0, -5), ScaleType = 1, Size = UDim2.new(1, 10, 1, 10), SliceCenter = Rect.new(6, 6, 25, 25), TileSize = UDim2.new(0, 20, 0, 20) } },
			{ 16, "UIGradient", { Parent = { 15 }, Rotation = -30, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0) }) } },
			{ 17, "UIGradient", { Parent = { 2 }, Rotation = -30, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 1, 0) }) } },
		})
		ak.ShowGui(am)
		local an = am.Main.UIGradient
		local ao = am.Main.Outlines.UIGradient
		local ap = am.Main.Holder.UIGradient
		local aq = am.Main.Holder.Title
		local as = am.Main.Holder.Desc
		local at = am.Main.Version
		local au = at.UIGradient
		local av = am.Main.Creator
		local aw = av.UIGradient
		local ax = am.Main.Holder.StatusText
		local ay = am.Main.Holder.ProgressBar
		local az = ag.TweenService

		local aA = ag.RunService.RenderStepped
		local aB = aA.wait
		local aD = function(aD)
			if not aD then
				return aB(aA)
			end
			local aE = tick()
			while tick() - aE < aD do
				aB(aA)
			end
		end

		ax.Text = al

		local function tweenNumber(aE, aF, aG)
			local aH = Instance.new("IntValue")
			aH.Value = 0
			aH.Changed:Connect(aG)
			local aI = az:Create(aH, aF, { Value = aE })
			aI:Play()
			aI.Completed:Connect(function()
				aH:Destroy()
			end)
		end

		local aE = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		tweenNumber(100, aE, function(aF)
			aF = aF / 200
			local aG = NumberSequenceKeypoint.new(0, 0)
			local aH = NumberSequenceKeypoint.new(aF, 0)
			local aI = NumberSequenceKeypoint.new(math.min(0.5, aF + math.min(0.05, aF)), 1)
			if aH.Time == aI.Time then
				aI = aH
			end
			local aJ = NumberSequenceKeypoint.new(1 - aF, 0)
			local aK = NumberSequenceKeypoint.new(math.max(0.5, 1 - aF - math.min(0.05, aF)), 1)
			if aJ.Time == aK.Time then
				aK = aJ
			end
			local aL = NumberSequenceKeypoint.new(1, 0)
			an.Transparency = NumberSequence.new({ aG, aH, aI, aK, aJ, aL })
			ao.Transparency = NumberSequence.new({ aG, aH, aI, aK, aJ, aL })
		end)

		aD(0.4)

		tweenNumber(100, aE, function(aF)
			aF = aF / 166.66
			local aG = NumberSequenceKeypoint.new(0, 0)
			local aH = NumberSequenceKeypoint.new(aF, 0)
			local aI = NumberSequenceKeypoint.new(aF + 0.01, 1)
			local aJ = NumberSequenceKeypoint.new(1, 1)
			ap.Transparency = NumberSequence.new({ aG, aH, aI, aJ })
		end)

		az:Create(aq, aE, { Position = UDim2.new(0, 60, 0, 15), TextTransparency = 0 }):Play()
		az:Create(as, aE, { Position = UDim2.new(0, 20, 0, 60), TextTransparency = 0 }):Play()

		local function rightTextTransparency(aF)
			tweenNumber(100, aE, function(aG)
				aG = aG / 100
				local aH = NumberSequenceKeypoint.new(1 - aG, 0)
				local aI = NumberSequenceKeypoint.new(math.max(0, 1 - aG - 0.01), 1)
				if aH.Time == aI.Time then
					aI = aH
				end
				local aJ = NumberSequenceKeypoint.new(0, aH == aI and 0 or 1)
				local aK = NumberSequenceKeypoint.new(1, 0)
				aF.Transparency = NumberSequence.new({ aJ, aI, aH, aK })
			end)
		end
		rightTextTransparency(au)
		rightTextTransparency(aw)

		aD(0.9)

		local aF = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		az:Create(ax, aF, { Position = UDim2.new(0, 20, 0, 120), TextTransparency = 0 }):Play()
		az:Create(ay, aF, { Position = UDim2.new(0, 60, 0, 145), Size = UDim2.new(0, 100, 0, 4) }):Play()

		aD(0.25)

		local function setProgress(aG, aH)
			ax.Text = aG
			az:Create(ay.Bar, aF, { Size = UDim2.new(aH, 0, 1, 0) }):Play()
		end

		local function close()
			az:Create(aq, aF, { TextTransparency = 1 }):Play()
			az:Create(as, aF, { TextTransparency = 1 }):Play()
			az:Create(at, aF, { TextTransparency = 1 }):Play()
			az:Create(av, aF, { TextTransparency = 1 }):Play()
			az:Create(ax, aF, { TextTransparency = 1 }):Play()
			az:Create(ay, aF, { BackgroundTransparency = 1 }):Play()
			az:Create(ay.Bar, aF, { BackgroundTransparency = 1 }):Play()
			az:Create(ay.ImageLabel, aF, { ImageTransparency = 1 }):Play()

			tweenNumber(100, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), function(aG)
				aG = aG / 250
				local aH = NumberSequenceKeypoint.new(0, 0)
				local aI = NumberSequenceKeypoint.new(0.6 + aG, 0)
				local aJ = NumberSequenceKeypoint.new(math.min(1, 0.601 + aG), 1)
				if aI.Time == aJ.Time then
					aJ = aI
				end
				local aK = NumberSequenceKeypoint.new(1, aI == aJ and 0 or 1)
				ap.Transparency = NumberSequence.new({ aH, aI, aJ, aK })
			end)

			aD(0.5)
			am.Main.BackgroundTransparency = 1
			ao.Rotation = 30

			tweenNumber(100, aE, function(aG)
				aG = aG / 100
				local aH = NumberSequenceKeypoint.new(0, 1)
				local aI = NumberSequenceKeypoint.new(aG, 1)
				local aJ = NumberSequenceKeypoint.new(math.min(1, aG + math.min(0.05, aG)), 0)
				if aI.Time == aJ.Time then
					aJ = aI
				end
				local aK = NumberSequenceKeypoint.new(1, aI == aJ and 1 or 0)
				ao.Transparency = NumberSequence.new({ aH, aI, aJ, aK })
				ap.Transparency = NumberSequence.new({ aH, aI, aJ, aK })
			end)

			aD(0.45)
			am:Destroy()
		end

		return { SetProgress = setProgress, Close = close }
	end

	ak.CreateApp = function(al)
		if ak.MenuApps[al.Name] then
			return
		end
		local am = {}

		local an = ak.AppTemplate:Clone()

		local ao = al.Icon
		if al.IconMap and ao then
			if type(ao) == "number" then
				al.IconMap:Display(an.Main.Icon, ao)
			elseif type(ao) == "string" then
				al.IconMap:DisplayByKey(an.Main.Icon, ao)
			end
		elseif type(ao) == "string" then
			an.Main.Icon.Image = ao
		else
			an.Main.Icon.Image = ""
		end

		local function updateState()
			an.Main.BackgroundTransparency = al.Open and 0 or (Lib.CheckMouseInGui(an.Main) and 0 or 1)
			an.Main.Highlight.Visible = al.Open
		end

		local function enable(ap)
			if al.Open then
				return
			end
			al.Open = true
			updateState()
			if not ap then
				if al.Window then
					al.Window:Show()
				end
				if al.OnClick then
					al.OnClick(al.Open)
				end
			end
		end

		local function disable(ap)
			if not al.Open then
				return
			end
			al.Open = false
			updateState()
			if not ap then
				if al.Window then
					al.Window:Hide()
				end
				if al.OnClick then
					al.OnClick(al.Open)
				end
			end
		end

		updateState()

		local ap = ag.TextService:GetTextSize(al.Name, 14, Enum.Font.SourceSans, Vector2.new(62, 999999)).Y
		an.Main.Size = UDim2.new(1, 0, 0, math.clamp(46 + ap, 60, 74))
		an.Main.AppName.Text = al.Name

		an.Main.InputBegan:Connect(function(aq)
			if aq.UserInputType == Enum.UserInputType.MouseMovement then
				an.Main.BackgroundTransparency = 0
				an.Main.BackgroundColor3 = ad.Theme.ButtonHover
			end
		end)

		an.Main.InputEnded:Connect(function(aq)
			if aq.UserInputType == Enum.UserInputType.MouseMovement then
				an.Main.BackgroundTransparency = al.Open and 0 or 1
				an.Main.BackgroundColor3 = ad.Theme.Button
			end
		end)

		an.Main.MouseButton1Click:Connect(function()
			if al.Open then
				disable()
			else
				enable()
			end
		end)

		local aq = al.Window
		if aq then
			aq.OnActivate:Connect(function()
				enable(true)
			end)
			aq.OnDeactivate:Connect(function()
				disable(true)
			end)
		end

		an.Visible = true
		an.Parent = ak.AppsContainer
		ak.AppsFrame.CanvasSize = UDim2.new(0, 0, 0, ak.AppsContainerGrid.AbsoluteCellCount.Y * 82 + 8)

		am.Enable = enable
		am.Disable = disable
		ak.MenuApps[al.Name] = am
		return am
	end

	ak.SetMainGuiOpen = function(al)
		ak.MainGuiOpen = al

		ak.MainGui.OpenButton.Text = al and "X" or "Dex"
		if al then
			ak.MainGui.OpenButton.MainFrame.Visible = true
		end
		ak.MainGui.OpenButton.MainFrame:TweenSize(al and UDim2.new(0, 224, 0, 200) or UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)

		ag.TweenService:Create(ak.MainGui.OpenButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = al and 0 or (Lib.CheckMouseInGui(ak.MainGui.OpenButton) and 0 or 0.2) }):Play()

		if ak.MainGuiMouseEvent then
			ak.MainGuiMouseEvent:Disconnect()
		end

		if not al then
			local am = tick()
			ak.MainGuiCloseTime = am
			coroutine.wrap(function()
				Lib.FastWait(0.2)
				if not ak.MainGuiOpen and am == ak.MainGuiCloseTime then
					ak.MainGui.OpenButton.MainFrame.Visible = false
				end
			end)()
		else
			ak.MainGuiMouseEvent = ag.UserInputService.InputBegan:Connect(function(am)
				if am.UserInputType == Enum.UserInputType.MouseButton1 and not Lib.CheckMouseInGui(ak.MainGui.OpenButton) and not Lib.CheckMouseInGui(ak.MainGui.OpenButton.MainFrame) then
					ak.SetMainGuiOpen(false)
				end
			end)
		end
	end

	ak.CreateMainGui = function()
		local al = ai({
			{ 1, "ScreenGui", { IgnoreGuiInset = true, Name = "MainMenu" } },
			{ 2, "TextButton", { AnchorPoint = Vector2.new(0.5, 0), AutoButtonColor = false, BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), BorderSizePixel = 0, Font = 4, Name = "OpenButton", Parent = { 1 }, Position = UDim2.new(0.5, 0, 0, 2), Size = UDim2.new(0, 32, 0, 32), Text = "Dex", TextColor3 = Color3.new(1, 1, 1), TextSize = 16, TextTransparency = 0.20000000298023 } },
			{ 3, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 2 } } },
			{ 4, "Frame", { AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799), ClipsDescendants = true, Name = "MainFrame", Parent = { 2 }, Position = UDim2.new(0.5, 0, 1, -4), Size = UDim2.new(0, 224, 0, 200) } },
			{ 5, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 4 } } },
			{ 6, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), Name = "BottomFrame", Parent = { 4 }, Position = UDim2.new(0, 0, 1, -24), Size = UDim2.new(1, 0, 0, 24) } },
			{ 7, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 6 } } },
			{ 8, "Frame", { BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394), BorderSizePixel = 0, Name = "CoverFrame", Parent = { 6 }, Size = UDim2.new(1, 0, 0, 4) } },
			{ 9, "Frame", { BackgroundColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935), BorderSizePixel = 0, Name = "Line", Parent = { 8 }, Position = UDim2.new(0, 0, 0, -1), Size = UDim2.new(1, 0, 0, 1) } },
			{ 10, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Settings", Parent = { 6 }, Position = UDim2.new(1, -48, 0, 0), Size = UDim2.new(0, 24, 1, 0), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
			{ 11, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://6578871732", ImageTransparency = 0.20000000298023, Name = "Icon", Parent = { 10 }, Position = UDim2.new(0, 4, 0, 4), Size = UDim2.new(0, 16, 0, 16) } },
			{ 12, "TextButton", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Font = 3, Name = "Information", Parent = { 6 }, Position = UDim2.new(1, -24, 0, 0), Size = UDim2.new(0, 24, 1, 0), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 14 } },
			{ 13, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://6578933307", ImageTransparency = 0.20000000298023, Name = "Icon", Parent = { 12 }, Position = UDim2.new(0, 4, 0, 4), Size = UDim2.new(0, 16, 0, 16) } },
			{ 14, "ScrollingFrame", { Active = true, AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935), BorderSizePixel = 0, Name = "AppsFrame", Parent = { 4 }, Position = UDim2.new(0.5, 0, 0, 0), ScrollBarImageColor3 = Color3.new(0, 0, 0), ScrollBarThickness = 4, Size = UDim2.new(0, 222, 1, -25) } },
			{ 15, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "Container", Parent = { 14 }, Position = UDim2.new(0, 7, 0, 8), Size = UDim2.new(1, -14, 0, 2) } },
			{ 16, "UIGridLayout", { CellSize = UDim2.new(0, 66, 0, 74), Parent = { 15 }, SortOrder = 2 } },
			{ 17, "Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Name = "App", Parent = { 1 }, Size = UDim2.new(0, 100, 0, 100), Visible = false } },
			{ 18, "TextButton", { AutoButtonColor = false, BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236), BorderSizePixel = 0, Font = 3, Name = "Main", Parent = { 17 }, Size = UDim2.new(1, 0, 0, 60), Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14 } },
			{ 19, "ImageLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Image = "rbxassetid://6579106223", ImageRectSize = Vector2.new(32, 32), Name = "Icon", Parent = { 18 }, Position = UDim2.new(0.5, -16, 0, 4), ScaleType = 4, Size = UDim2.new(0, 32, 0, 32) } },
			{ 20, "TextLabel", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Font = 3, Name = "AppName", Parent = { 18 }, Position = UDim2.new(0, 2, 0, 38), Size = UDim2.new(1, -4, 1, -40), Text = "Explorer", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextTransparency = 0.10000000149012, TextTruncate = 1, TextWrapped = true, TextYAlignment = 0 } },
			{ 21, "Frame", { BackgroundColor3 = Color3.new(0, 0.66666668653488, 1), BorderSizePixel = 0, Name = "Highlight", Parent = { 18 }, Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2) } },
		})
		ak.MainGui = al
		ak.AppsFrame = al.OpenButton.MainFrame.AppsFrame
		ak.AppsContainer = ak.AppsFrame.Container
		ak.AppsContainerGrid = ak.AppsContainer.UIGridLayout
		ak.AppTemplate = al.App
		ak.MainGuiOpen = false

		local am = al.OpenButton
		am.BackgroundTransparency = 0.2
		am.MainFrame.Size = UDim2.new(0, 0, 0, 0)
		am.MainFrame.Visible = false
		am.MouseButton1Click:Connect(function()
			ak.SetMainGuiOpen(not ak.MainGuiOpen)
		end)

		am.InputBegan:Connect(function(an)
			if an.UserInputType == Enum.UserInputType.MouseMovement then
				ag.TweenService:Create(ak.MainGui.OpenButton, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
			end
		end)

		am.InputEnded:Connect(function(an)
			if an.UserInputType == Enum.UserInputType.MouseMovement then
				ag.TweenService:Create(ak.MainGui.OpenButton, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = ak.MainGuiOpen and 0 or 0.2 }):Play()
			end
		end)

		ak.CreateApp({ Name = "Explorer", IconMap = ak.LargeIcons, Icon = "Explorer", Open = true, Window = Explorer.Window })

		ak.CreateApp({ Name = "Properties", IconMap = ak.LargeIcons, Icon = "Properties", Open = true, Window = Properties.Window })

		ak.CreateApp({ Name = "Script Viewer", IconMap = ak.LargeIcons, Icon = "Script_Viewer", Window = ScriptViewer.Window })

		local an
		ak.CreateApp({
			Name = "Click part to select",
			IconMap = ak.LargeIcons,
			Icon = 6,
			OnClick = function(ao)
				if ao then
					local ap = ak.Mouse
					an = ap.Button1Down:Connect(function()
						pcall(function()
							local aq = ap.Target
							if g[aq] then
								h:Set(g[aq])
								Explorer.ViewNode(g[aq])
							end
						end)
					end)
				else
					if an ~= nil then
						an:Disconnect()
						an = nil
					end
				end
			end,
		})

		Lib.ShowGui(al)
	end

	ak.SetupFilesystem = function()
		if not af.writefile or not af.makefolder then
			return
		end
		local al, am = af.writefile, af.makefolder
		am("dex")
		am("dex/assets")
		am("dex/saved")
		am("dex/plugins")
		am("dex/ModuleCache")
	end

	ak.LocalDepsUpToDate = function()
		return ak.DepsVersionData and ak.ClientVersion == ak.DepsVersionData[1]
	end

	ak.Init = function()
		ak.Elevated = pcall(function()
			i(game:GetService("CoreGui")):GetFullName()
		end)
		ak.InitEnv()
		ak.LoadSettings()
		ak.SetupFilesystem()

		local al = ak.CreateIntro("Initializing Library")
		Lib = ak.LoadModule("Lib")
		Lib.FastWait()

		ak.MiscIcons = Lib.IconMap.new("rbxassetid://6511490623", 256, 256, 16, 16)
		ak.MiscIcons:SetDict({
			Reference = 0,
			Cut = 1,
			Cut_Disabled = 2,
			Copy = 3,
			Copy_Disabled = 4,
			Paste = 5,
			Paste_Disabled = 6,
			Delete = 7,
			Delete_Disabled = 8,
			Group = 9,
			Group_Disabled = 10,
			Ungroup = 11,
			Ungroup_Disabled = 12,
			TeleportTo = 13,
			Rename = 14,
			JumpToParent = 15,
			ExploreData = 16,
			Save = 17,
			CallFunction = 18,
			CallRemote = 19,
			Undo = 20,
			Undo_Disabled = 21,
			Redo = 22,
			Redo_Disabled = 23,
			Expand_Over = 24,
			Expand = 25,
			Collapse_Over = 26,
			Collapse = 27,
			SelectChildren = 28,
			SelectChildren_Disabled = 29,
			InsertObject = 30,
			ViewScript = 31,
			AddStar = 32,
			RemoveStar = 33,
			Script_Disabled = 34,
			LocalScript_Disabled = 35,
			Play = 36,
			Pause = 37,
			Rename_Disabled = 38,
		})
		ak.LargeIcons = Lib.IconMap.new("rbxassetid://6579106223", 256, 256, 32, 32)
		ak.LargeIcons:SetDict({
			Explorer = 0,
			Properties = 1,
			Script_Viewer = 2,
		})

		al.SetProgress("Fetching Roblox Version", 0.2)
		if ak.Elevated then
			local am = Lib.ReadFile("dex/deps_version.dat")
			ak.ClientVersion = Version()
			if am then
				ak.DepsVersionData = string.split(am, "\n")
				if ak.LocalDepsUpToDate() then
					ak.RobloxVersion = ak.DepsVersionData[2]
				end
			end
			ak.RobloxVersion = ak.RobloxVersion or game:HttpGet("http://setup.roblox.com/versionQTStudio")
		end

		al.SetProgress("Fetching API", 0.35)
		ab = ak.FetchAPI()
		Lib.FastWait()
		al.SetProgress("Fetching RMD", 0.5)
		ac = ak.FetchRMD()
		Lib.FastWait()

		if ak.Elevated and af.writefile and not ak.LocalDepsUpToDate() then
			af.writefile("dex/deps_version.dat", ak.ClientVersion .. "\n" .. ak.RobloxVersion)
			af.writefile("dex/rbx_api.dat", ak.RawAPI)
			af.writefile("dex/rbx_rmd.dat", ak.RawRMD)
		end

		al.SetProgress("Loading Modules", 0.75)
		ak.AppControls.Lib.InitDeps(ak.GetInitDeps())
		ak.LoadModules()
		Lib.FastWait()

		al.SetProgress("Initializing Modules", 0.9)
		Explorer.Init()
		Properties.Init()
		ScriptViewer.Init()
		Lib.FastWait()

		al.SetProgress("Complete", 1)
		coroutine.wrap(function()
			Lib.FastWait(1.25)
			al.Close()
		end)()

		Lib.Window.Init()
		ak.CreateMainGui()
		Explorer.Window:Show({ Align = "right", Pos = 1, Size = 0.5, Silent = true })
		Properties.Window:Show({ Align = "right", Pos = 2, Size = 0.5, Silent = true })
		Lib.DeferFunc(function()
			Lib.Window.ToggleSide("right")
		end)
	end

	return ak
end)()

Main.Init()
