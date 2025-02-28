// 型定義を追加
type FontWeight = '400' | '500' | '700';

interface Typography {
  fontSize: {
    small: number;
    medium: number;
    large: number;
    xlarge: number;
  };
  fontWeight: {
    regular: FontWeight;
    medium: FontWeight;
    bold: FontWeight;
  };
}

interface Colors {
  primary: string;
  secondary: string;
  background: string;
  text: {
    primary: string;
    secondary: string;
  };
  border: string;
}

interface Spacing {
  xs: number;
  sm: number;
  md: number;
  lg: number;
  xl: number;
}

interface Layout {
  borderRadius: {
    small: number;
    medium: number;
    large: number;
  };
  containerPadding: number;
}

// 既存のexport constに型を追加
export const colors = {
  primary: '#E75480',     // ピンク系のプライマリカラー
  secondary: '#FFFFFF',   // 白
  background: '#F8F8F8', // 薄いグレー
  text: {
    primary: '#000000',
    secondary: '#666666',
  },
  border: '#EEEEEE',
};

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
};

export const typography = {
  fontSize: {
    small: 12,
    medium: 14,
    large: 16,
    xlarge: 20,
  },
  fontWeight: {
    regular: '400' as const,
    medium: '500' as const,
    bold: '700' as const,
  }
};

// 共通のボーダーラディウスなど
export const layout = {
  borderRadius: {
    small: 8,
    medium: 12,
    large: 16,
  },
  containerPadding: 16,
}; 