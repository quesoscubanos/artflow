import 'package:flutter/material.dart';
import 'package:artflowrise/core/theme/app_theme.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard('Total Users', '1,234', Icons.people, AppTheme.primaryBlue),
                _buildStatCard('Active Tutorials', '89', Icons.school, AppTheme.primaryPink),
                _buildStatCard('Pending Reviews', '23', Icons.pending, Colors.orange),
                _buildStatCard('Gallery Posts', '456', Icons.image, Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final activities = [
                  {'text': 'Sarah_Artist uploaded a new artwork', 'icon': Icons.image, 'time': '2 hours ago'},
                  {'text': 'Mike_Draws completed a tutorial', 'icon': Icons.school, 'time': '3 hours ago'},
                  {'text': 'New user Emma_Art registered', 'icon': Icons.person_add, 'time': '5 hours ago'},
                  {'text': 'Tutorial was approved', 'icon': Icons.check_circle, 'time': '6 hours ago'},
                  {'text': 'Content was reported', 'icon': Icons.report, 'time': '8 hours ago'},
                ];
                
                final activity = activities[index];
                return _buildActivityItem(
                  activity['text'] as String,
                  activity['time'] as String,
                  activity['icon'] as IconData,
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2,
              children: [
                _buildActionCard('Manage Users', Icons.people, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User management feature coming soon!')),
                  );
                }),
                _buildActionCard('Review Content', Icons.rate_review, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content review feature coming soon!')),
                  );
                }),
                _buildActionCard('Create Tutorial', Icons.add_circle, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tutorial creation feature coming soon!')),
                  );
                }),
                _buildActionCard('View Reports', Icons.analytics, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reports feature coming soon!')),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
        ),
        title: Text(
          activity,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
