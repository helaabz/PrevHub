import 'package:flutter/material.dart';
import 'bourse_missions_view.dart';
import 'sollicitations_view.dart';
import 'mes_missions_view.dart';

class MissionView extends StatefulWidget {
  const MissionView({super.key});

  @override
  State<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends State<MissionView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _pendingSolicitations = 3; // Badge count

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              MesMissionsView(),
              BourseMissionsView(),
              SollicitationsView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildTab('Mes Missions', 0),
          ),
          Expanded(
            child: _buildTab('Missions ouvertes', 1),
          ),
          Expanded(
            child: _buildTab('Missions ciblées', 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive
                        ? const Color(0xFFFF4D3D)
                        : const Color(0xFF999999),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (label == 'Missions ciblées' && _pendingSolicitations > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      '$_pendingSolicitations',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth * 0.8,
                height: 2,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFFF4D3D) : Colors.transparent,
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
