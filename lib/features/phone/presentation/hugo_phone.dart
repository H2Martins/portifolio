import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

const _linkedInUrl =
    'https://www.linkedin.com/in/hugo-henrique-martins-54198016a/';
const _githubUrl = 'https://github.com/H2Martins';

Future<void> showHugoPhone(BuildContext context) => showGeneralDialog<void>(
  context: context,
  barrierDismissible: true,
  barrierLabel: 'Fechar Hugo OS',
  barrierColor: const Color(0xD908090B),
  transitionDuration: 600.ms,
  pageBuilder: (context, _, _) => const _PhoneOverlay(),
  transitionBuilder: (context, animation, _, child) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutExpo,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween(begin: .88, end: 1.0).animate(curved),
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, .16),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      ),
    );
  },
);

class _PhoneOverlay extends StatelessWidget {
  const _PhoneOverlay();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
            ),
          ),
          SafeArea(
            minimum: EdgeInsets.all(compact ? 0 : 24),
            child: Center(
              child: compact
                  ? const _PhoneFrame(fullScreen: true)
                  : const FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 500,
                        height: 900,
                        child: _PhoneFrame(fullScreen: false),
                      ),
                    ),
            ),
          ),
          if (!compact)
            Positioned(
              right: 28,
              top: 28,
              child: IconButton.filledTonal(
                tooltip: 'Fechar',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
        ],
      ),
    );
  }
}

class _PhoneFrame extends StatefulWidget {
  const _PhoneFrame({required this.fullScreen});

  final bool fullScreen;

  @override
  State<_PhoneFrame> createState() => _PhoneFrameState();
}

class _PhoneFrameState extends State<_PhoneFrame> {
  _PhoneApp? _openApp;

  Future<void> _open(_PhoneApp app) async {
    if (app.url == null) {
      setState(() => _openApp = app);
      return;
    }

    final opened = await launchUrl(
      Uri.parse(app.url!),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir este link.')),
      );
    }
  }

  void _goHome() => setState(() => _openApp = null);

  @override
  Widget build(BuildContext context) {
    final radius = widget.fullScreen ? 0.0 : 52.0;
    return Container(
      key: const ValueKey('hugo-phone-frame'),
      width: widget.fullScreen ? double.infinity : 500,
      height: widget.fullScreen ? double.infinity : 900,
      padding: EdgeInsets.all(widget.fullScreen ? 0 : 7),
      decoration: BoxDecoration(
        color: const Color(0xFF030406),
        borderRadius: BorderRadius.circular(radius),
        border: widget.fullScreen
            ? null
            : Border.all(color: Colors.white.withValues(alpha: .17)),
        boxShadow: widget.fullScreen
            ? null
            : const [
                BoxShadow(
                  color: Color(0x99000000),
                  blurRadius: 80,
                  offset: Offset(0, 35),
                ),
                BoxShadow(
                  color: Color(0x259B8CFF),
                  blurRadius: 70,
                  spreadRadius: -12,
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.fullScreen ? 0 : 45),
        child: ColoredBox(
          color: const Color(0xFF0B0C10),
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 16),
            child: Stack(
              children: [
                const Positioned.fill(child: _PhoneWallpaper()),
                SafeArea(
                  child: Column(
                    children: [
                      const _StatusBar(),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: 350.ms,
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween(
                                    begin: .96,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: _openApp == null
                              ? _HomeScreen(
                                  key: const ValueKey('home'),
                                  onOpen: _open,
                                )
                              : _openApp!.isContact
                              ? _ContactScreen(
                                  key: const ValueKey('contact'),
                                  onBack: _goHome,
                                )
                              : _openApp!.isAbout
                              ? _AboutScreen(
                                  key: const ValueKey('about'),
                                  onBack: _goHome,
                                )
                              : _AppScreen(
                                  key: ValueKey(_openApp!.title),
                                  app: _openApp!,
                                  onBack: _goHome,
                                ),
                        ),
                      ),
                      _HomeIndicator(onTap: _goHome),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 11, 20, 6),
    child: Row(
      children: [
        const Text(
          '09:41',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Container(
          width: 76,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const Spacer(),
        const Icon(Icons.signal_cellular_alt_rounded, size: 14),
        const SizedBox(width: 5),
        const Icon(Icons.wifi_rounded, size: 14),
        const SizedBox(width: 5),
        const Icon(Icons.battery_full_rounded, size: 16),
      ],
    ),
  );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({super.key, required this.onOpen});

  final ValueChanged<_PhoneApp> onOpen;

  static const apps = [
    _PhoneApp(
      title: 'Contato',
      subtitle: 'Vamos construir algo',
      icon: Icons.alternate_email_rounded,
      colors: [Color(0xFFFFB86B), Color(0xFFDB6238)],
      isContact: true,
    ),
    _PhoneApp(
      title: 'GitHub',
      subtitle: 'Código & contribuições',
      icon: Icons.code_rounded,
      colors: [Color(0xFF34343D), Color(0xFF17171C)],
      url: _githubUrl,
    ),
    _PhoneApp(
      title: 'LinkedIn',
      subtitle: 'Perfil profissional',
      icon: Icons.work_outline_rounded,
      colors: [Color(0xFF1785D1), Color(0xFF005A9E)],
      url: _linkedInUrl,
    ),
    _PhoneApp(
      title: 'Nexus',
      subtitle: 'Projeto conceito · em breve',
      icon: Icons.hub_outlined,
      colors: [Color(0xFF9B8CFF), Color(0xFF5542D6)],
      description:
          'Uma plataforma conectada, pensada para transformar fluxos complexos em uma experiência simples.',
    ),
    _PhoneApp(
      title: 'Pulse',
      subtitle: 'Projeto conceito · em breve',
      icon: Icons.graphic_eq_rounded,
      colors: [Color(0xFF72E6B1), Color(0xFF168867)],
      description:
          'Um produto real-time criado para tornar dados vivos, claros e imediatamente acionáveis.',
    ),
    _PhoneApp(
      title: 'Sobre',
      subtitle: 'Minha trajetória e propósito',
      icon: Icons.person_outline_rounded,
      colors: [Color(0xFF6EA8FF), Color(0xFF3657D6)],
      isAbout: true,
    ),
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(34, 34, 34, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HUGO OS',
          style: TextStyle(
            color: Colors.white.withValues(alpha: .46),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.8,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Explore meu trabalho.',
          style: TextStyle(
            fontSize: 40,
            height: 1.02,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.7,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Projetos, código e conexões em um só lugar.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: .52),
            fontSize: 19,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 44),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 30,
              crossAxisSpacing: 20,
              childAspectRatio: .82,
            ),
            itemCount: apps.length,
            itemBuilder: (context, index) =>
                _AppIcon(app: apps[index], onTap: () => onOpen(apps[index])),
          ),
        ),
      ],
    ),
  );
}

class _AppIcon extends StatefulWidget {
  const _AppIcon({required this.app, required this.onTap});

  final _PhoneApp app;
  final VoidCallback onTap;

  @override
  State<_AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<_AppIcon> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Abrir ${widget.app.title}',
    child: InkWell(
      onTap: widget.onTap,
      onHover: (value) => setState(() => hovered = value),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          AnimatedScale(
            duration: 180.ms,
            scale: hovered ? 1.08 : 1,
            child: _AppGlyph(app: widget.app, size: 78),
          ),
          const SizedBox(height: 11),
          Text(
            widget.app.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -.1,
            ),
          ),
        ],
      ),
    ),
  );
}

class _AppGlyph extends StatelessWidget {
  const _AppGlyph({required this.app, this.size = 62});

  final _PhoneApp app;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: app.colors,
      ),
      borderRadius: BorderRadius.circular(size * .27),
      border: Border.all(color: Colors.white.withValues(alpha: .16)),
      boxShadow: [
        BoxShadow(
          color: app.colors.last.withValues(alpha: .24),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Icon(app.icon, color: Colors.white, size: size * .42),
  );
}

class _AppScreen extends StatelessWidget {
  const _AppScreen({super.key, required this.app, required this.onBack});

  final _PhoneApp app;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          tooltip: 'Voltar à tela inicial',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const Spacer(),
        _AppGlyph(app: app, size: 78),
        const SizedBox(height: 24),
        Text(
          app.title,
          style: const TextStyle(
            fontSize: 38,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          app.description ?? app.subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .58),
            fontSize: 18,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 34),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: app.colors.first.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: app.colors.first.withValues(alpha: .3)),
          ),
          child: const Text(
            'PROJETO EM BREVE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  static const _paragraphs = [
    'Sou Desenvolvedor Full Stack apaixonado por transformar ideias em soluções digitais modernas, intuitivas e de alto desempenho.',
    'Atualmente desenvolvo aplicações utilizando Flutter, .NET, React e tecnologias voltadas para sistemas em tempo real, sempre buscando criar experiências fluidas, escaláveis e bem estruturadas. Acredito que um bom software vai além de funcionar: ele precisa ser confiável, performático e agradável de usar.',
    'Tenho grande interesse por arquitetura de software, aplicações offline-first, sincronização de dados, comunicação em tempo real e desenvolvimento multiplataforma. Gosto de compreender profundamente os desafios antes de propor soluções, priorizando código limpo, manutenção simples e uma excelente experiência para o usuário.',
    'Acredito que os melhores resultados surgem da combinação entre curiosidade, aprendizado contínuo e atenção aos detalhes. Gosto de resolver problemas complexos criando soluções simples, equilibrando qualidade técnica com uma experiência intuitiva para quem utiliza o produto.',
    'Estou em constante evolução, estudando novas tecnologias e aprimorando minhas habilidades para desenvolver produtos que gerem impacto real. Encaro cada projeto como uma oportunidade de aprender, evoluir e entregar algo melhor do que a versão anterior.',
    'Meu objetivo é construir aplicações que unam qualidade técnica, desempenho e uma experiência que faça diferença para as pessoas.',
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Voltar à tela inicial',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF6EA8FF).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF6EA8FF).withValues(alpha: .24),
                ),
              ),
              child: const Text(
                'SOBRE MIM',
                style: TextStyle(
                  color: Color(0xFF91BAFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(4, 24, 4, 28),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 76,
                  height: 76,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6EA8FF), Color(0xFF3657D6)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x403657D6),
                        blurRadius: 28,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Text(
                    'HM',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.7,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Sobre mim',
                style: TextStyle(
                  fontSize: 40,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.7,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _paragraphs.first,
                style: const TextStyle(
                  color: Color(0xFFE7E7EC),
                  fontSize: 20,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -.1,
                ),
              ),
              const SizedBox(height: 28),
              Divider(color: Colors.white.withValues(alpha: .1)),
              const SizedBox(height: 20),
              for (final paragraph in _paragraphs.skip(1)) ...[
                Text(
                  paragraph,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .58),
                    fontSize: 18,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _ContactScreen extends StatelessWidget {
  const _ContactScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  Future<void> _openLink(BuildContext context, String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir este contato.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Voltar à tela inicial',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF72E6B1).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF72E6B1).withValues(alpha: .22),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusDot(),
                  SizedBox(width: 7),
                  Text(
                    'DISPONÍVEL',
                    style: TextStyle(
                      color: Color(0xFF8FE8BD),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(2, 22, 2, 18),
            children: [
              Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFB86B), Color(0xFFDB6238)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x35DB6238),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Text(
                      'HM',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hugo Martins',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -.4,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Full Stack Developer',
                          style: TextStyle(
                            color: Color(0xFF999AA4),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Vamos construir\nalgo relevante.',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.02,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Escolha o canal mais conveniente. Estou sempre aberto a boas conversas e novos desafios.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .5),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              _ContactTile(
                label: 'LOCALIDADE',
                value: 'Araçoiaba da Serra · SP',
                icon: Icons.location_on_outlined,
                accent: const Color(0xFF9B8CFF),
                onTap: () => _openLink(
                  context,
                  'https://www.google.com/maps/search/?api=1&query=Ara%C3%A7oiaba%20da%20Serra%20SP',
                ),
              ),
              const SizedBox(height: 10),
              _ContactTile(
                label: 'E-MAIL',
                value: 'hhugomts@gmail.com',
                icon: Icons.alternate_email_rounded,
                accent: const Color(0xFFFFB86B),
                onTap: () => _openLink(context, 'mailto:hhugomts@gmail.com'),
              ),
              const SizedBox(height: 10),
              _ContactTile(
                label: 'TELEFONE',
                value: '(15) 99610-6082',
                icon: Icons.phone_outlined,
                accent: const Color(0xFF72E6B1),
                onTap: () => _openLink(context, 'tel:+5515996106082'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ContactTile extends StatefulWidget {
  const _ContactTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${widget.label}: ${widget.value}',
    child: AnimatedContainer(
      duration: 180.ms,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: hovered ? .09 : .055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hovered
              ? widget.accent.withValues(alpha: .38)
              : Colors.white.withValues(alpha: .08),
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (value) => setState(() => hovered = value),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(widget.icon, color: widget.accent, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .35),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white.withValues(alpha: .3),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _StatusDot extends StatelessWidget {
  const _StatusDot();

  @override
  Widget build(BuildContext context) => Container(
    width: 6,
    height: 6,
    decoration: const BoxDecoration(
      color: Color(0xFF72E6B1),
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Color(0x9972E6B1), blurRadius: 6)],
    ),
  );
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
      child: Container(
        width: 120,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  );
}

class _PhoneWallpaper extends StatelessWidget {
  const _PhoneWallpaper();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(.85, -.65),
        radius: 1.25,
        colors: [Color(0x443F2A8C), Color(0x0017192A)],
      ),
    ),
    child: CustomPaint(painter: const _WallpaperGrid()),
  );
}

class _WallpaperGrid extends CustomPainter {
  const _WallpaperGrid();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0DFFFFFF)
      ..strokeWidth = .5;
    const gap = 40.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PhoneApp {
  const _PhoneApp({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    this.url,
    this.description,
    this.isContact = false,
    this.isAbout = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final String? url;
  final String? description;
  final bool isContact;
  final bool isAbout;
}
